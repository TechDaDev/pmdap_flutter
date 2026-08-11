# PMDAP Mobile — UI ↔ API Response Alignment Matrix

Tracks how every patient-facing screen maps backend API responses to the UI:
endpoints, DTOs, fields shown, status → badge semantics, date localization, and
RTL / digital-ID LTR handling.

Source of truth: `pmdap_backend` @ `edb3969`. Envelope: `{"data": ...}`,
error `{"error": {code, message, details}}`, page size 20.

## Shared presentation layer

| Helper | Location | Purpose |
| --- | --- | --- |
| `documentTypeIcon(MedicalDocumentType)` | `lib/core/utils/presentation.dart` | Icon per document type |
| `facilityDisplayName(...)` | `lib/core/utils/presentation.dart` | Canonical facility name → `facilityName` → `locationText` → `''` |
| `localizedDate(l10n, DateTime?)` | `lib/core/utils/presentation.dart` | `DateFormat('d MMM y', locale)` (en/ar), `''` when null |
| `patientInitials(String)` | `lib/core/utils/presentation.dart` | First+last initials, Arabic-safe, `?` fallback |
| `fileSizeLabel(int?)` | `lib/core/utils/presentation.dart` | B / KB / MB |
| `StatusLabels(l10n)` | `lib/core/utils/status_labels.dart` | Localized labels + semantic `StatusBadge`s |
| `DocumentCard` | `lib/core/widgets/document_card.dart` | Archive/search card |
| `MedicalDocumentCard` | `lib/features/documents/presentation/medical_document_card.dart` | Recent/home documents card |
| `PatientCard` | `lib/core/widgets/patient_card.dart` | Patient/minor summary card |
| `PatientAvatar` | `lib/core/widgets/patient_avatar.dart` | Authenticated avatar (bytes) or initials fallback |

## Avatar contract

- DTO: `PatientProfile.avatarUrl` (snake_case `avatar_url`) — route hint, `null`
  when absent. Never a public storage URL.
- Fetch: `GET /patients/me/avatar/` (authenticated, binary `image/*`).
  `ApiPaths.patientAvatar` = `/patients/me/avatar/`. Uses `ResponseType.bytes`;
  NOT the JSON envelope. 404/503/network → initials fallback.
- Upload/change: `PATCH /patients/me/` multipart `avatar=<file>` (JPEG/PNG only).
- Remove: `PATCH /patients/me/` JSON `{"avatar": null}`.
- Cache: in-memory `patientAvatarProvider` (FutureProvider.autoDispose) — shared
  by Profile + Home; recomputes on profile change (upload/remove) and on auth
  change (login/logout/account switch). No disk, no public URL, no token in URL.
- Editing is allowed even when `identity_status == VERIFIED` (avatar is not part
  of the backend identity-locked fields).

## Status → badge semantics

| Status | Semantic badge |
| --- | --- |
| `VerificationStatus` verified/pending/rejected/unknown | success / warning / error / neutral |
| `IdentityDocumentLifecycleStatus` current/expired/replaced/revoked/unknown | success / warning / neutral / error / neutral |
| `IntegrityStatus` corrupted/quarantined/missing/pending/valid | error / error / error / warning / success |
| `IdentityStatus` | semantic badge (`labels.identity`) |
| `ProcessingStatus` | semantic badge (`labels.processing`) |

## Screens

### Home (`/`)
- Endpoint: `GET /patients/me/`, `GET /documents/?page=…`, archive summary.
- DTOs: `PatientProfile`, `MedicalDocument`, `ArchiveSummary`.
- AppBar avatar: `PatientAvatar` (authenticated image, else initials); tap → Profile.
- Digital ID card: `profile.digitalId` rendered LTR inside Arabic UI.
- Identity card: `labels.identity(profile.identityStatus)` semantic badge.
- "Needs confirmation" shortcut: `unconfirmedDateCount` → opens Archive with
  `date_status=UNCONFIRMED` (never combined with year/month).

### Profile (`/profile`)
- Endpoint: `GET /patients/me/`.
- DTO: `PatientProfile`.
- Avatar: `patientInitials(fullName)`; badge: `labels.identity(identityStatus)`.
- DOB: `localizedDate`; Digital ID row LTR; blank nationality → `notProvided`.
- No UUID, no internal ids shown.

### Identity documents (list `/identity`, detail `/identity/:uuid`)
- Endpoint: `GET /identity-documents/`, `GET /identity-documents/:uuid/`.
- DTOs: `IdentityDocumentSummary`, `IdentityDocumentDetail`.
- List row: localized type + lifecycle badge + verification badge.
- Detail: semantic verification + lifecycle badges; localized issue/expiry dates;
  rejection reason shown only when `verificationStatus == rejected`;
  image buttons label `viewFront` / `viewBack`.

### Documents — archive & recent
- Endpoint: `GET /documents/` (recent, filtered).
- DTOs: `MedicalDocument`, `ArchiveDocument`.
- Card: type icon, `facilityDisplayName`, `localizedDate(documentDate)`,
  blank-title fallback = localized document-type label.

### Document detail (`/documents/:uuid`)
- Endpoint: `GET /documents/:uuid/`.
- DTO: `MedicalDocumentDetail`.
- Type row: `labels.medicalDocumentTypeLabel(documentType)` (never raw `.api`).
- Date row: `localizedDate(documentDate)`; fallback `needsDateConfirmation` /
  `dateNotDetected`; verified → `dateConfirmedState`.
- Facility: `facilityDisplayName`; empty physician/department rows hidden.
- File info: collapsible `ExpansionTile` — fileName/type/size/pages + integrity badge.

### Minors (list `/minors`, detail `/minors/:uuid`)
- Endpoint: `GET /minors/`, `GET /minors/:uuid/`.
- DTOs: `Minor`, `GuardianRelationship`.
- List row: `patientInitials(fullName)`, localized DOB, Digital ID LTR,
  relationship verification badge; PENDING relationships disabled.
- Detail: Digital ID row (LTR), age, localized DOB, identity status,
  relationship + relationship verification status.

### Facilities
- Endpoint: `GET /healthcare-facilities/`.
- DTO: `HealthcareFacility`.
- Subtitle fallback: `labels.facilityTypeLabel(facilityType)` when no city/region.

## Dates

- Display: `localizedDate` → `d MMM y` in current locale (en: "17 Sep 2025",
  ar: "17 سبتمبر 2025").
- API/request formatting stays `formatApiDate` (ISO) — display only is localized.
- Missing dates render `notProvided` / `dateNotDetected` / `needsDateConfirmation`.

## RTL / digital-ID LTR

- Arabic UI: `EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.end`.
- Digital IDs (patient/minor) and `PT-…` identifiers wrapped in
  `Directionality(textDirection: TextDirection.ltr)`.

## Test coverage

`test/widgets/api_presentation_test.dart` exercises realistic snake_case
fixtures: profile identity states, facility fallback, Arabic date + digital-ID
LTR, minor relationship status.
