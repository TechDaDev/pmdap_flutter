import 'dart:async';

import 'package:flutter/foundation.dart';
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
    this.passwordError,
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

  /// Backend password-field message shown inline on Step 1 after a rejected
  /// final registration. Never the raw password value.
  final String? passwordError;

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
    String? passwordError,
    bool clearPasswordError = false,
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
      passwordError: clearPasswordError
          ? null
          : passwordError ?? this.passwordError,
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
  DateTime? _pollStartedAt;

  /// Hard cap for a single extraction poll window. Real worker OCR on the
  /// Iraqi V2 pipeline can take ~4.5 minutes, so 8 minutes is a safe ceiling.
  static final Duration _maxPollWindow = const Duration(minutes: 8);

  @override
  RegistrationFlowState build() => const RegistrationFlowState();

  RegistrationApi get _api => ref.read(registrationApiProvider);

  void setCredentials({
    required String email,
    String phone = '',
    required String password,
    required String governorate,
  }) {
    // If a successful extraction job already exists (e.g. returning from a
    // rejected final registration), Continue jumps straight to Step 3. No new
    // extraction job, no re-upload.
    final identityReady =
        state.jobId != null &&
        state.extractionResult != null &&
        state.extractionStatus == ExtractionJobStatus.success;
    state = state.copyWith(
      step: identityReady ? RegistrationStep.review : RegistrationStep.scan,
      draft: RegistrationDraft(
        email: email,
        phone: phone,
        password: password,
        governorate: governorate,
      ),
      errorMessage: null,
      clearPasswordError: true,
    );
  }

  /// Step 3 -> Step 2 (back). Keeps the extraction job/result + reviewed
  /// values so nothing needs rescanning.
  void backToScan() {
    _pollTimer?.cancel();
    state = state.copyWith(
      step: RegistrationStep.scan,
      errorMessage: null,
      reading: false,
    );
  }

  /// Step 2 (already-read) -> Step 3.
  void goToReview() {
    state = state.copyWith(step: RegistrationStep.review, errorMessage: null);
  }

  void clearPasswordError() {
    if (state.passwordError != null) {
      state = state.copyWith(clearPasswordError: true);
    }
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
    _pollStartedAt = DateTime.now();
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
      if (kDebugMode) {
        debugPrint(
          'registration_extract job=${job.jobId} status=${job.jobToken.isNotEmpty ? 'OK' : 'MISSING_TOKEN'}',
        );
      }
      state = state.copyWith(
        jobId: job.jobId,
        jobToken: job.jobToken,
        uploadProgress: 100,
      );
      _schedulePoll();
    } catch (e) {
      // Catch ANY error (Exception or Error) so a POST failure can never
      // leave the UI stuck on "Reading document...".
      if (kDebugMode)
        debugPrint('registration_extract FAILED ${e.runtimeType}');
      state = state.copyWith(
        reading: false,
        errorMessage: state.errorMessage ?? 'extraction_failed',
      );
    }
  }

  void _schedulePoll() {
    _pollTimer?.cancel();
    // Hard deadline: real OCR can legitimately take ~4.5 minutes on the
    // worker, so allow up to 8 minutes before giving up with a recoverable
    // error. A deadline is safer than an unbounded silent loop.
    final started = _pollStartedAt;
    if (started != null &&
        DateTime.now().difference(started) > _maxPollWindow) {
      _stopPolling('extraction_failed');
      return;
    }
    // Backstop count (should never be reached before the deadline).
    if (_pollCount >= 400) {
      _stopPolling('extraction_failed');
      return;
    }
    _pollCount += 1;
    _pollTimer = Timer(const Duration(milliseconds: 1500), _pollOnce);
  }

  void _stopPolling(String message) {
    _pollTimer?.cancel();
    _pollTimer = null;
    state = state.copyWith(
      reading: false,
      extractionStatus: ExtractionJobStatus.failed,
      errorMessage: message,
    );
  }

  Future<void> _pollOnce() async {
    final jobId = state.jobId;
    final token = state.jobToken;
    // A missing/empty job identity means the poll can never succeed. Stop
    // with a recoverable error instead of silently letting the loop die
    // (which previously left the UI stuck on "Reading document..." forever).
    if (jobId == null || jobId.isEmpty || token == null || token.isEmpty) {
      _stopPolling('session_invalid');
      return;
    }
    try {
      final status = await _api.pollExtraction(jobId: jobId, jobToken: token);
      if (kDebugMode) {
        debugPrint(
          'registration_poll job=$jobId attempt=$_pollCount status=${status.status.name}',
        );
      }
      switch (status.status) {
        case ExtractionJobStatus.pending:
        case ExtractionJobStatus.processing:
          _schedulePoll();
        case ExtractionJobStatus.success:
          if (kDebugMode) debugPrint('registration_poll job=$jobId SUCCESS');
          _onExtractionSuccess(status.result);
        case ExtractionJobStatus.failed:
          _stopPolling('extraction_failed');
        case ExtractionJobStatus.unknown:
          _schedulePoll();
      }
    } on ApiException catch (e) {
      // Terminal server errors must STOP the loop, never retry silently
      // forever (the old behaviour left the UI stuck on "Reading...").
      // Transient network/throttle errors keep retrying.
      final terminal =
          e.code == 'registration_job_not_found' ||
          e.code == 'registration_job_expired' ||
          e.code == 'registration_job_conflict' ||
          e.isUnauthorized ||
          e.isForbidden ||
          e.isNotFound ||
          (e.statusCode != null && e.statusCode! >= 500) ||
          e.code == 'invalid_response';
      if (kDebugMode) {
        debugPrint(
          'registration_poll job=$jobId attempt=$_pollCount error=${e.code} status=${e.statusCode} terminal=$terminal',
        );
      }
      if (terminal) {
        _stopPolling(_pollErrorKey(e));
      } else {
        _schedulePoll();
      }
    } on Exception {
      // Transient transport/parse failure — keep retrying until deadline.
      _schedulePoll();
    }
  }

  String _pollErrorKey(ApiException e) {
    if (e.isUnauthorized ||
        e.isForbidden ||
        e.isNotFound ||
        e.code == 'registration_job_not_found' ||
        e.code == 'registration_job_conflict') {
      return 'session_invalid';
    }
    if (e.code == 'registration_job_expired') return 'session_expired';
    if (e.statusCode != null && e.statusCode! >= 500) return 'server_error';
    return 'extraction_failed';
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
      // A backend password rejection must send the user back to Step 1 with
      // the password focused + the exact server message inline. Everything
      // else stays on the review step with the retained identity state.
      if (e.details.containsKey('password')) {
        state = state.copyWith(
          submitting: false,
          submitError: e,
          step: RegistrationStep.account,
          passwordError: _passwordFieldMessage(e),
        );
      } else {
        state = state.copyWith(submitting: false, submitError: e);
      }
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

  /// Backend password detail (List<String> or String) without the field name.
  String? _passwordFieldMessage(ApiException e) {
    final value = e.details['password'];
    if (value is List && value.isNotEmpty) return value.first.toString();
    if (value is String && value.isNotEmpty) return value;
    return null;
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
