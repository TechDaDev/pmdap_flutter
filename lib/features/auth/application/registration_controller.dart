import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/enums.dart';
import '../../../core/storage/registration_session_storage.dart';
import '../../../core/utils/date_utils.dart';
import '../../identity/data/extraction_models.dart';
import '../data/registration_api.dart';
import '../data/registration_models.dart';

enum RegistrationStep { account, verifyEmail, scan, review }

/// Client-side view of the email-verification attempt budget. The backend
/// returns a generic error for invalid/expired/locked codes (no OTP oracle);
/// the UI tracks its own attempt count to show a locked state.
const int _maxVerifyAttempts = 5;
const Duration _otpTtl = Duration(minutes: 10);

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
    this.motherName = '',
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
  final String motherName;
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
    String? motherName,
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
      motherName: motherName ?? this.motherName,
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
    this.emailSession,
    this.emailVerified = false,
    this.maskedEmail = '',
    this.verifyBusy = false,
    this.verifyError,
    this.verifyAttempts = 0,
    this.otpExpiresAt,
    this.resendAt,
    this.resendCountdown = 0,
    this.resuming = false,
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

  /// M31B email-verification session (holds the capability token in memory).
  final RegistrationEmailSession? emailSession;
  final bool emailVerified;
  final String maskedEmail;

  /// True while a verify/start/resend request is in flight.
  final bool verifyBusy;

  /// Localized error key for the verify step (null = no error).
  final String? verifyError;

  /// Client-side OTP attempt budget (backend stays generic to avoid an oracle).
  final int verifyAttempts;

  /// Client-side hint for when the current code expires (resend resets it).
  final DateTime? otpExpiresAt;

  /// Server cooldown window after which resend is allowed.
  final DateTime? resendAt;
  final int resendCountdown;

  /// True while restoring a persisted registration session on app start.
  final bool resuming;

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
    RegistrationEmailSession? emailSession,
    bool? emailVerified,
    String? maskedEmail,
    bool? verifyBusy,
    String? verifyError,
    bool clearVerifyError = false,
    int? verifyAttempts,
    DateTime? otpExpiresAt,
    DateTime? resendAt,
    int? resendCountdown,
    bool? resuming,
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
      emailSession: emailSession ?? this.emailSession,
      emailVerified: emailVerified ?? this.emailVerified,
      maskedEmail: maskedEmail ?? this.maskedEmail,
      verifyBusy: verifyBusy ?? this.verifyBusy,
      verifyError: clearVerifyError ? null : (verifyError ?? this.verifyError),
      verifyAttempts: verifyAttempts ?? this.verifyAttempts,
      otpExpiresAt: otpExpiresAt ?? this.otpExpiresAt,
      resendAt: resendAt ?? this.resendAt,
      resendCountdown: resendCountdown ?? this.resendCountdown,
      resuming: resuming ?? this.resuming,
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
/// are never persisted. Email verification survives refresh/restart via a
/// persisted session capability (see [tryResumeRegistration]); the password is
/// never persisted and is re-entered after a restart.
class RegistrationController extends Notifier<RegistrationFlowState> {
  Timer? _pollTimer;
  Timer? _countdownTimer;
  int _pollCount = 0;
  DateTime? _pollStartedAt;

  /// Hard cap for a single extraction poll window. Real worker OCR on the
  /// Iraqi V2 pipeline can take ~4.5 minutes, so 8 minutes is a safe ceiling.
  static final Duration _maxPollWindow = const Duration(minutes: 8);

  @override
  RegistrationFlowState build() => const RegistrationFlowState();

  RegistrationApi get _api => ref.read(registrationApiProvider);

  RegistrationSessionStorage get _storage =>
      ref.read(registrationSessionStorageProvider);

  Future<void> setCredentials({
    required String email,
    String phone = '',
    required String password,
    required String governorate,
  }) async {
    // If a successful extraction job already exists (e.g. returning from a
    // rejected final registration), Continue jumps straight to review. No new
    // extraction job, no re-upload, and the email was already verified.
    final identityReady =
        state.jobId != null &&
        state.extractionResult != null &&
        state.extractionStatus == ExtractionJobStatus.success;
    state = state.copyWith(
      step: identityReady
          ? RegistrationStep.review
          : RegistrationStep.verifyEmail,
      draft: RegistrationDraft(
        email: email,
        phone: phone,
        password: password,
        governorate: governorate,
      ),
      errorMessage: null,
      clearPasswordError: true,
      clearVerifyError: true,
    );
    if (!identityReady) {
      await startEmailVerification();
    }
  }

  /// Step: back from email verification -> account details.
  void backToAccount() {
    _stopCountdown();
    state = state.copyWith(
      step: RegistrationStep.account,
      errorMessage: null,
      verifyError: null,
      verifyBusy: false,
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

  // ---------------------------------------------------------------------
  // M31B email verification
  // ---------------------------------------------------------------------

  /// Create the registration session server-side and send the first OTP.
  Future<void> startEmailVerification() async {
    final draft = state.draft;
    if (draft == null) return;
    state = state.copyWith(verifyBusy: true, clearVerifyError: true);
    try {
      final session = await _api.startEmailVerification(
        email: draft.email,
        phone: draft.phone.isEmpty ? null : draft.phone,
        governorate: draft.governorate.isEmpty ? null : draft.governorate,
      );
      await _storage.write(
        RegistrationSessionRecord(
          sessionToken: session.sessionToken,
          email: draft.email,
          phone: draft.phone,
          governorate: draft.governorate,
        ),
      );
      _stopCountdown();
      state = state.copyWith(
        step: RegistrationStep.verifyEmail,
        emailSession: session,
        emailVerified: false,
        maskedEmail: session.maskedEmail,
        verifyBusy: false,
        verifyError: null,
        verifyAttempts: 0,
        otpExpiresAt: DateTime.now().add(_otpTtl),
        resendAt: session.resendAt,
      );
      _startCountdown();
    } on ApiException catch (e) {
      state = state.copyWith(
        verifyBusy: false,
        verifyError: _mapVerifyError(e),
      );
    } on Exception {
      state = state.copyWith(
        verifyBusy: false,
        verifyError: 'verification_failed',
      );
    }
  }

  /// Resend the OTP. Server cooldown/limits gate it; a 429 with a retry window
  /// restarts the countdown instead of erroring.
  Future<void> resendEmailVerification() async {
    final token = state.emailSession?.sessionToken;
    if (token == null || token.isEmpty || state.resendCountdown > 0) return;
    state = state.copyWith(verifyBusy: true, clearVerifyError: true);
    try {
      final status = await _api.resendEmailVerification(sessionToken: token);
      state = state.copyWith(
        verifyBusy: false,
        verifyError: null,
        verifyAttempts: 0,
        otpExpiresAt: DateTime.now().add(_otpTtl),
        resendAt: status.resendAt,
        maskedEmail: status.maskedEmail,
      );
      _startCountdown();
    } on ApiException catch (e) {
      if (e.isThrottled) {
        final retry = e.details['retry_after'];
        if (retry is num && retry > 0) {
          state = state.copyWith(
            verifyBusy: false,
            verifyError: null,
            resendAt: DateTime.now().add(Duration(seconds: retry.toInt())),
          );
          _startCountdown();
          return;
        }
      }
      state = state.copyWith(
        verifyBusy: false,
        verifyError: _mapVerifyError(e),
      );
    } on Exception {
      state = state.copyWith(
        verifyBusy: false,
        verifyError: 'verification_failed',
      );
    }
  }

  /// Verify the 6-digit code. On success the server marks the session email
  /// verified and the flow proceeds to the identity scan step.
  Future<void> verifyEmailCode(String code) async {
    final token = state.emailSession?.sessionToken;
    if (token == null || token.isEmpty) return;
    // Client-side expired hint (backend also denies expired codes).
    final expiresAt = state.otpExpiresAt;
    if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
      state = state.copyWith(verifyError: 'code_expired');
      return;
    }
    state = state.copyWith(verifyBusy: true, clearVerifyError: true);
    try {
      final status = await _api.verifyEmail(sessionToken: token, code: code);
      _stopCountdown();
      state = state.copyWith(
        verifyBusy: false,
        step: RegistrationStep.scan,
        emailVerified: true,
        maskedEmail: status.maskedEmail,
        verifyError: null,
        verifyAttempts: 0,
        otpExpiresAt: null,
      );
    } on ApiException catch (e) {
      final attempts = state.verifyAttempts + 1;
      if (attempts >= _maxVerifyAttempts) {
        state = state.copyWith(
          verifyBusy: false,
          verifyAttempts: attempts,
          verifyError: 'code_locked',
        );
      } else {
        state = state.copyWith(
          verifyBusy: false,
          verifyAttempts: attempts,
          verifyError: _mapVerifyError(e),
        );
      }
    } on Exception {
      state = state.copyWith(
        verifyBusy: false,
        verifyError: 'verification_failed',
      );
    }
  }

  /// Resume-safe: restore a persisted registration session after a restart.
  ///
  /// The server session is authoritative. A verified session resumes straight
  /// to the identity scan; an unverified one resumes the verify step. The
  /// password is never persisted, so after a restart it must be re-entered
  /// (empty draft password → the final submit bounces back to Step 1).
  Future<void> tryResumeRegistration() async {
    if (state.draft != null) return; // active in-memory flow wins.
    final record = await _storage.read();
    if (record == null) return;
    state = state.copyWith(resuming: true);
    try {
      final status = await _api.getEmailVerificationStatus(
        sessionToken: record.sessionToken,
      );
      if (status.verified) {
        state = state.copyWith(
          resuming: false,
          step: RegistrationStep.scan,
          draft: RegistrationDraft(
            email: record.email,
            phone: record.phone,
            password: '',
            governorate: record.governorate,
          ),
          emailSession: _sessionFromStatus(status, record.sessionToken),
          emailVerified: true,
          maskedEmail: status.maskedEmail,
          clearVerifyError: true,
        );
      } else {
        _stopCountdown();
        state = state.copyWith(
          resuming: false,
          step: RegistrationStep.verifyEmail,
          draft: RegistrationDraft(
            email: record.email,
            phone: record.phone,
            password: '',
            governorate: record.governorate,
          ),
          emailSession: _sessionFromStatus(status, record.sessionToken),
          emailVerified: false,
          maskedEmail: status.maskedEmail,
          verifyAttempts: 0,
          resendAt: status.resendAt,
          clearVerifyError: true,
        );
        _startCountdown();
      }
    } on ApiException {
      // Expired / not found / already used session → start fresh.
      await _storage.clear();
      state = state.copyWith(resuming: false);
    } on Exception {
      // Transient failure: keep the account step; user can retry.
      state = state.copyWith(resuming: false);
    }
  }

  /// Abandon the current session (used from the verify step "start over").
  Future<void> startOver() async {
    _stopCountdown();
    _pollTimer?.cancel();
    await _storage.clear();
    state = const RegistrationFlowState(step: RegistrationStep.account);
  }

  RegistrationEmailSession _sessionFromStatus(
    RegistrationEmailStatus status,
    String token,
  ) {
    return RegistrationEmailSession(
      sessionId: status.sessionId,
      sessionToken: token,
      maskedEmail: status.maskedEmail,
      status: status.status,
      emailVerified: status.emailVerified,
      resendAt: status.resendAt,
      expiresAt: status.expiresAt,
    );
  }

  String _mapVerifyError(ApiException e) {
    if (e.isThrottled) return 'throttled';
    if (e.code == 'registration_session_expired' ||
        e.code == 'registration_session_not_found') {
      return 'session_expired';
    }
    if (e.code == 'registration_email_delivery_failed') {
      return 'delivery_failed';
    }
    if (e.code == 'validation_error' ||
        e.code == 'registration_email_already_verified') {
      return 'invalid_code';
    }
    if (e.isNetwork) return 'network';
    if (e.statusCode != null && e.statusCode! >= 500) return 'server_error';
    return 'verification_failed';
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    final target = state.resendAt;
    if (target == null) {
      state = state.copyWith(resendCountdown: 0);
      return;
    }
    void tick() {
      final remaining = target.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        _countdownTimer?.cancel();
        state = state.copyWith(resendCountdown: 0);
      } else {
        state = state.copyWith(resendCountdown: remaining);
      }
    }

    tick();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    state = state.copyWith(resendCountdown: 0);
  }

  void clearVerifyError() {
    if (state.verifyError != null) {
      state = state.copyWith(clearVerifyError: true);
    }
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

  /// Start the scan-first extraction. Uploads images exactly once. Refuses to
  /// proceed without a server-verified email session (the backend enforces the
  /// same gate).
  Future<void> startExtraction() async {
    final front = state.frontPath;
    final back = state.backPath;
    final sessionToken = state.emailSession?.sessionToken ?? '';
    if (front == null || back == null) return;
    if (sessionToken.isEmpty) {
      state = state.copyWith(
        reading: false,
        errorMessage: 'email_verification_required',
      );
      return;
    }
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
        sessionToken: sessionToken,
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
      if (kDebugMode) {
        debugPrint('registration_extract FAILED ${e.runtimeType}');
      }
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
      motherName: (v('mother_name') ?? '').trim(),
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
    final sessionToken = state.emailSession?.sessionToken ?? '';
    final review = state.review;
    if (draft == null || jobId == null || jobToken == null) return false;
    if (sessionToken.isEmpty) return false;
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
        sessionToken: sessionToken,
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
          motherName: review.motherName,
          confirmation: review.confirmation,
          dateOfBirth: review.dateOfBirth,
          sex: review.sex,
          nationality: 'IQ',
          bloodGroup: review.bloodGroup,
        ),
      );
      // Clear in-memory sensitive state (incl. password) + the persisted
      // session capability after success.
      _stopCountdown();
      await _storage.clear();
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

  /// Backend password detail (list of strings or string) without the field name.
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

  Future<void> reset() async {
    _pollTimer?.cancel();
    _stopCountdown();
    await _storage.clear();
    state = const RegistrationFlowState();
  }
}

final registrationControllerProvider =
    NotifierProvider<RegistrationController, RegistrationFlowState>(
      RegistrationController.new,
    );
