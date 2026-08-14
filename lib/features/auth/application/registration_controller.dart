import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/utils/date_utils.dart';
import '../../identity/data/extraction_models.dart';
import '../data/registration_api.dart';
import '../data/registration_models.dart';

enum RegistrationStep { account, scan, review }

/// In-memory account credentials. Password is kept ONLY here until the final
/// register request — never persisted to disk, never sent to the extraction
/// endpoint, never stored in the registration session.
class RegistrationDraft {
  const RegistrationDraft({
    required this.email,
    this.phone = '',
    required this.password,
    required this.governorate,
  });

  final String email;
  final String phone;
  final String password;
  final String governorate;
}

/// Confirmed, human-reviewed registration values (authoritative at submit).
class RegistrationReviewValues {
  const RegistrationReviewValues({
    this.name = '',
    this.fatherName = '',
    this.grandfatherName = '',
    this.sex = Sex.unspecified,
    this.bloodGroup = BloodGroup.unknown,
    this.dateOfBirth,
    this.documentNumber = '',
    this.nationalCardNumber = '',
    this.familyNumber = '',
    this.uniqueCardBodyNumber = '',
    this.confirmation = false,
  });

  final String name;
  final String fatherName;
  final String grandfatherName;
  final Sex sex;
  final BloodGroup bloodGroup;
  final DateTime? dateOfBirth;
  final String documentNumber;
  final String nationalCardNumber;
  final String familyNumber;
  final String uniqueCardBodyNumber;
  final bool confirmation;

  RegistrationReviewValues copyWith({
    String? name,
    String? fatherName,
    String? grandfatherName,
    Sex? sex,
    BloodGroup? bloodGroup,
    DateTime? dateOfBirth,
    String? documentNumber,
    String? nationalCardNumber,
    String? familyNumber,
    String? uniqueCardBodyNumber,
    bool? confirmation,
  }) {
    return RegistrationReviewValues(
      name: name ?? this.name,
      fatherName: fatherName ?? this.fatherName,
      grandfatherName: grandfatherName ?? this.grandfatherName,
      sex: sex ?? this.sex,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      documentNumber: documentNumber ?? this.documentNumber,
      nationalCardNumber: nationalCardNumber ?? this.nationalCardNumber,
      familyNumber: familyNumber ?? this.familyNumber,
      uniqueCardBodyNumber: uniqueCardBodyNumber ?? this.uniqueCardBodyNumber,
      confirmation: confirmation ?? this.confirmation,
    );
  }
}

class RegistrationFlowState {
  const RegistrationFlowState({
    this.step = RegistrationStep.account,
    this.draft,
    this.frontPath,
    this.backPath,
    this.jobId,
    this.jobToken,
    this.extractionStatus = ExtractionJobStatus.unknown,
    this.extractionResult,
    this.uploadProgress,
    this.reading = false,
    this.errorMessage,
    this.submitError,
    this.review = const RegistrationReviewValues(),
    this.submitting = false,
  });

  final RegistrationStep step;
  final RegistrationDraft? draft;
  final String? frontPath;
  final String? backPath;
  final String? jobId;
  final String? jobToken;
  final ExtractionJobStatus extractionStatus;
  final IdentityExtractionResult? extractionResult;
  final int? uploadProgress;
  final bool reading;
  final String? errorMessage;

  /// Typed backend error from the final register attempt (never logs values).
  final ApiException? submitError;
  final RegistrationReviewValues review;
  final bool submitting;

  RegistrationFlowState copyWith({
    RegistrationStep? step,
    RegistrationDraft? draft,
    String? frontPath,
    String? backPath,
    String? jobId,
    String? jobToken,
    ExtractionJobStatus? extractionStatus,
    IdentityExtractionResult? extractionResult,
    int? uploadProgress,
    bool? reading,
    String? errorMessage,
    ApiException? submitError,
    RegistrationReviewValues? review,
    bool? submitting,
  }) {
    return RegistrationFlowState(
      step: step ?? this.step,
      draft: draft ?? this.draft,
      frontPath: frontPath ?? this.frontPath,
      backPath: backPath ?? this.backPath,
      jobId: jobId ?? this.jobId,
      jobToken: jobToken ?? this.jobToken,
      extractionStatus: extractionStatus ?? this.extractionStatus,
      extractionResult: extractionResult ?? this.extractionResult,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      reading: reading ?? this.reading,
      errorMessage: errorMessage ?? this.errorMessage,
      submitError: submitError ?? this.submitError,
      review: review ?? this.review,
      submitting: submitting ?? this.submitting,
    );
  }
}

/// Orchestrates the scan-first registration flow.
///
/// State is in-memory only: images, job capability, credentials and password
/// are never persisted. A killed process restarts registration.
class RegistrationController extends Notifier<RegistrationFlowState> {
  Timer? _pollTimer;
  int _pollCount = 0;

  @override
  RegistrationFlowState build() => const RegistrationFlowState();

  RegistrationApi get _api => ref.read(registrationApiProvider);

  void setCredentials({
    required String email,
    String phone = '',
    required String password,
    required String governorate,
  }) {
    state = state.copyWith(
      step: RegistrationStep.scan,
      draft: RegistrationDraft(
        email: email,
        phone: phone,
        password: password,
        governorate: governorate,
      ),
      errorMessage: null,
    );
  }

  void setScannedPaths({String? front, String? back}) {
    state = state.copyWith(
      frontPath: front ?? state.frontPath,
      backPath: back ?? state.backPath,
      errorMessage: null,
    );
  }

  void backToAccount() {
    _pollTimer?.cancel();
    state = state.copyWith(
      step: RegistrationStep.account,
      errorMessage: null,
      reading: false,
    );
  }

  /// Start the scan-first extraction. Uploads images exactly once.
  Future<void> startExtraction() async {
    final front = state.frontPath;
    final back = state.backPath;
    if (front == null || back == null) return;
    _pollTimer?.cancel();
    _pollCount = 0;
    state = state.copyWith(
      reading: true,
      errorMessage: null,
      uploadProgress: 0,
      extractionStatus: ExtractionJobStatus.pending,
    );
    try {
      final job = await _api.startExtraction(
        frontPath: front,
        backPath: back,
        onSendProgress: (sent, total) {
          if (total > 0) {
            state = state.copyWith(
              uploadProgress: (sent * 100 / total).round(),
            );
          }
        },
      );
      state = state.copyWith(
        jobId: job.jobId,
        jobToken: job.jobToken,
        uploadProgress: 100,
      );
      _schedulePoll();
    } on Exception {
      state = state.copyWith(
        reading: false,
        errorMessage: state.errorMessage ?? 'extraction_failed',
      );
    }
  }

  void _schedulePoll() {
    _pollTimer?.cancel();
    // Bound polling (backend TTL is 30 minutes; 10 minutes of polls is
    // plenty and avoids an endless background timer).
    if (_pollCount >= 400) {
      state = state.copyWith(
        reading: false,
        extractionStatus: ExtractionJobStatus.failed,
        errorMessage: 'extraction_failed',
      );
      return;
    }
    _pollCount += 1;
    _pollTimer = Timer(const Duration(milliseconds: 1500), _pollOnce);
  }

  Future<void> _pollOnce() async {
    final jobId = state.jobId;
    final token = state.jobToken;
    if (jobId == null || token == null) return;
    try {
      final status = await _api.pollExtraction(jobId: jobId, jobToken: token);
      switch (status.status) {
        case ExtractionJobStatus.pending:
        case ExtractionJobStatus.processing:
          _schedulePoll();
        case ExtractionJobStatus.success:
          _onExtractionSuccess(status.result);
        case ExtractionJobStatus.failed:
          state = state.copyWith(
            reading: false,
            extractionStatus: ExtractionJobStatus.failed,
            errorMessage: 'extraction_failed',
          );
        case ExtractionJobStatus.unknown:
          _schedulePoll();
      }
    } on Exception {
      // Transient poll failure — keep retrying unless we have a result.
      if (state.extractionStatus != ExtractionJobStatus.success) {
        _schedulePoll();
      }
    }
  }

  void _onExtractionSuccess(IdentityExtractionResult? result) {
    if (result == null) {
      state = state.copyWith(
        reading: false,
        extractionStatus: ExtractionJobStatus.failed,
        errorMessage: 'extraction_failed',
      );
      return;
    }
    final fields = result.fields;
    String? v(String key) => fields[key]?.value;

    final review = RegistrationReviewValues(
      name: (v('name') ?? '').trim(),
      fatherName: (v('father_name') ?? '').trim(),
      grandfatherName: (v('grandfather_name') ?? '').trim(),
      sex: Sex.fromApi(v('sex')),
      bloodGroup: BloodGroup.fromApi(v('blood_group')),
      dateOfBirth: parseApiDate(v('date_of_birth')),
      documentNumber: (v('document_number') ?? '').trim(),
      nationalCardNumber:
          (v('national_card_number') ?? v('document_number') ?? '').trim(),
      familyNumber: (v('family_number') ?? '').trim(),
      uniqueCardBodyNumber: (v('unique_card_body_number') ?? '').trim(),
      confirmation: false,
    );
    state = state.copyWith(
      reading: false,
      extractionStatus: ExtractionJobStatus.success,
      extractionResult: result,
      review: review,
      step: RegistrationStep.review,
      errorMessage: null,
    );
  }

  void updateReview(RegistrationReviewValues review) {
    state = state.copyWith(review: review, errorMessage: null);
  }

  Future<bool> submit() async {
    final draft = state.draft;
    final jobId = state.jobId;
    final jobToken = state.jobToken;
    final review = state.review;
    if (draft == null || jobId == null || jobToken == null) return false;
    state = state.copyWith(
      submitting: true,
      errorMessage: null,
      submitError: null,
    );
    try {
      await _api.registerScanFirst(
        email: draft.email,
        phone: draft.phone,
        password: draft.password,
        governorate: draft.governorate,
        identity: RegistrationIdentityInput(
          jobId: jobId,
          jobToken: jobToken,
          documentType: IdentityDocumentType.unifiedNationalCard,
          documentNumber: review.documentNumber,
          nationalCardNumber: review.nationalCardNumber,
          familyNumber: review.familyNumber,
          uniqueCardBodyNumber: review.uniqueCardBodyNumber,
          name: review.name,
          fatherName: review.fatherName,
          grandfatherName: review.grandfatherName,
          confirmation: review.confirmation,
          dateOfBirth: review.dateOfBirth,
          sex: review.sex,
          nationality: 'IQ',
          bloodGroup: review.bloodGroup,
        ),
      );
      // Clear in-memory sensitive state (incl. password) after success.
      state = const RegistrationFlowState(step: RegistrationStep.account);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(submitting: false, submitError: e);
      return false;
    } on Exception {
      state = state.copyWith(
        submitting: false,
        submitError: const ApiException(
          code: 'unknown',
          message: 'Unexpected error.',
        ),
      );
      return false;
    }
  }

  /// Expired/consumed job → return to scan step with local images preserved
  /// so the user can retry without rescanning.
  void retryScan() {
    _pollTimer?.cancel();
    state = state.copyWith(
      step: RegistrationStep.scan,
      jobId: null,
      jobToken: null,
      extractionStatus: ExtractionJobStatus.unknown,
      extractionResult: null,
      reading: false,
      errorMessage: null,
    );
  }

  void reset() {
    _pollTimer?.cancel();
    state = const RegistrationFlowState();
  }
}

final registrationControllerProvider =
    NotifierProvider<RegistrationController, RegistrationFlowState>(
      RegistrationController.new,
    );
