/// Central API path constants. Mirrors the frozen backend contract at /api/v1/.
class ApiPaths {
  ApiPaths._();

  static const health = '/health/';
  static const login = '/auth/login/';
  static const register = '/auth/register/';
  static const refresh = '/auth/refresh/';
  static const logout = '/auth/logout/';
  static const me = '/auth/me/';
  static const activateClaimedAccount = '/auth/activate-claimed-account/';

  static const patientsMe = '/patients/me/';
  static const patientAvatar = '/patients/me/avatar/';

  static const identityDocuments = '/identity-documents/';
  static const identityExtract = '/identity-documents/extract/';
  static String identityExtractStatus(String jobId) =>
      '/identity-documents/extract/$jobId/';
  static String identityDocumentDetail(String uuid) =>
      '/identity-documents/$uuid/';
  static String identityDocumentReplace(String uuid) =>
      '/identity-documents/$uuid/replace/';
  static String identityDocumentImage(String uuid, String side) =>
      '/identity-documents/$uuid/images/$side/';

  // Scan-first registration (public, capability-bound anonymous endpoints).
  static const registrationIdentityExtract = '/auth/register/identity/extract/';
  static String registrationIdentityExtractStatus(String jobId) =>
      '/auth/register/identity/extract/$jobId/';

  // M31B pre-registration email verification (public, capability-bound).
  static const registrationEmailStart = '/auth/register/email/start/';
  static const registrationEmailResend = '/auth/register/email/resend/';
  static const registrationEmailVerify = '/auth/register/email/verify/';
  static const registrationEmailStatus = '/auth/register/email/status/';

  static const minors = '/minors/';
  static const guardianRelationships = '/guardian-relationships/';
  static String guardianRelationshipDetail(String uuid) =>
      '/guardian-relationships/$uuid/';
  static String guardianRelationshipDismiss(String uuid) =>
      '/guardian-relationships/$uuid/dismiss/';
  static String guardianRelationshipRevoke(String uuid) =>
      '/minors/relationships/$uuid/revoke/';
  static String minorDetail(String uuid) => '/minors/$uuid/';
  static String minorArchive(String uuid) => '/minors/$uuid/archive/';
  static String minorArchiveSummary(String uuid) =>
      '/minors/$uuid/archive/summary/';
  static String minorDocuments(String uuid) => '/minors/$uuid/documents/';
  static String minorDocumentDetail(String minor, String doc) =>
      '/minors/$minor/documents/$doc/';
  static String minorDocumentFile(String minor, String doc) =>
      '/minors/$minor/documents/$doc/file/';
  static String minorDocumentLabResults(String minor, String doc) =>
      '/minors/$minor/documents/$doc/lab-results/';
  static String minorDocumentExtractedContent(String minor, String doc) =>
      '/minors/$minor/documents/$doc/extracted-content/';
  static String minorDocumentCandidates(String minor, String doc) =>
      '/minors/$minor/documents/$doc/date-candidates/';
  static String minorDocumentConfirmDate(String minor, String doc) =>
      '/minors/$minor/documents/$doc/confirm-date/';
  static String minorPendingDateConfirmations(String minor) =>
      '/minors/$minor/documents/date-confirmations/pending/';
  static String minorDocumentPages(String minor, String doc) =>
      '/minors/$minor/documents/$doc/pages/';
  static String minorDocumentPageDetail(
    String minor,
    String doc,
    int pageNumber,
  ) => '/minors/$minor/documents/$doc/pages/$pageNumber/';
  static String minorDocumentPageLabResults(
    String minor,
    String doc,
    int pageNumber,
  ) => '/minors/$minor/documents/$doc/pages/$pageNumber/lab-results/';
  static String minorDocumentPageConfirmDate(
    String minor,
    String doc,
    int pageNumber,
  ) => '/minors/$minor/documents/$doc/pages/$pageNumber/confirm-date/';
  static String minorSearch(String minor) => '/minors/$minor/search/';

  static const documents = '/documents/';
  static String documentDetail(String uuid) => '/documents/$uuid/';
  static String documentFile(String uuid) => '/documents/$uuid/file/';
  static String documentLabResults(String uuid) =>
      '/documents/$uuid/lab-results/';
  static String documentExtractedContent(String uuid) =>
      '/documents/$uuid/extracted-content/';
  static String documentCandidates(String uuid) =>
      '/documents/$uuid/date-candidates/';
  static String documentConfirmDate(String uuid) =>
      '/documents/$uuid/confirm-date/';
  static String documentPages(String uuid) => '/documents/$uuid/pages/';
  static String documentPageDetail(String uuid, int pageNumber) =>
      '/documents/$uuid/pages/$pageNumber/';
  static String documentPageLabResults(String uuid, int pageNumber) =>
      '/documents/$uuid/pages/$pageNumber/lab-results/';
  static String documentPageConfirmDate(String uuid, int pageNumber) =>
      '/documents/$uuid/pages/$pageNumber/confirm-date/';
  static const pendingDateConfirmations =
      '/documents/date-confirmations/pending/';

  static const facilities = '/facilities/';
  static String facilityDetail(String uuid) => '/facilities/$uuid/';

  static const archive = '/archive/';
  static const archiveSummary = '/archive/summary/';

  static const search = '/search/';

  static const accountClaims = '/account-claims/';
}
