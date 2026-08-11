# PMDAP Flutter ↔ Django API Contract Matrix

Source of truth: `pmdap_backend` (SHA `edb3969`) — read-only, NOT modified.
Live API: `https://pmdapbackend.up.railway.app/api/v1`

Envelope: success `{"data": ...}`; error `{"error": {"code","message","details"}}`.
Page shape: `{"data": {"count","next","previous","results":[]}}`, page size 20.

## Auth
| Feature | Endpoint | Method | Auth | Request | Success | Errors |
|---|---|---|---|---|---|---|
| register | /auth/register/ | POST | public | email, phone?, password, patient{full_name,date_of_birth,sex,nationality,blood_group} | 201 {data: PublicUser} | validation_error, account_unavailable |
| login | /auth/login/ | POST | public | email, password | 200 {data:{access,refresh}} | invalid_credentials, account_unavailable |
| refresh | /auth/refresh/ | POST | public | refresh | 200 {data:{access,refresh}} | invalid token |
| logout | /auth/logout/ | POST | auth | refresh | 200 | invalid_credentials |
| me | /auth/me/ | GET | auth | — | 200 {data: PublicUser} | not_authenticated |
| activate-claimed-account | /auth/activate-claimed-account/ | POST | public | token(20-256), new_password | 200 {data:{message}} | validation_error, throttled |

## Patient
| Feature | Endpoint | Method | Auth | Request | Success | Errors |
|---|---|---|---|---|---|---|
| profile | /patients/me/ | GET | auth | — | 200 {data: PatientProfile} | not_authenticated |
| profile edit | /patients/me/ | PATCH | auth | any of full_name,date_of_birth,sex,nationality,blood_group (all optional) | 200 {data} | validation_error; VERIFIED profile rejects full_name/date_of_birth/sex/nationality ("Verified identity fields require controlled review.") |

## Identity
| Feature | Endpoint | Method | Auth | Request | Success | Errors |
|---|---|---|---|---|---|---|
| list | /identity-documents/ | GET | auth | page | 200 page of summary | not_authenticated |
| detail | /identity-documents/{uuid}/ | GET | auth | — | 200 detail | not_found |
| replace | /identity-documents/{uuid}/replace/ | POST | auth | multipart (IdentityDocumentInputSerializer) | 200 detail | validation_error, not_found, throttled |
| images | /identity-documents/{uuid}/images/{front|back}/ | GET | auth | — | 200 jpeg/png | not_found |

IdentityDocumentInputSerializer conditional rules:
- UNIFIED_NATIONAL_CARD: issuing_country→"IQ" if absent; national_number required; back_image required; family_number required **adult only** (not minor); issuing_country must == IQ.
- PASSPORT: issuing_country, issue_date, expiry_date required; front_image required; back_image optional.
- other: issuing_country required.
- Dates: issue_date <= today; expiry_date > issue_date; expiry_date >= today.
- Images: JPEG/PNG only (inspect_identity_upload).

## Minors / Guardians
| Feature | Endpoint | Method | Auth | Request | Success | Errors |
|---|---|---|---|---|---|---|
| list | /minors/ | GET | auth (eligible guardian) | page | 200 page of Minor (incl PENDING relationships) | 403 guardian_not_verified |
| create | /minors/ | POST | auth (eligible guardian) | multipart + Idempotency-Key header (1-128 chars) | 200 replay / 201 created | guardian_not_verified, patient_not_minor, relationship_evidence_required, idempotency_key_required, invalid_idempotency_key, idempotency_conflict(409), validation_error |
| detail | /minors/{uuid}/ | GET | auth (VERIFIED+active relationship) | — | 200 Minor | not_found |
| archive | /minors/{uuid}/archive/ | GET | auth (VERIFIED+active) | filters | 200 ArchivePage | not_found |
| archive summary | /minors/{uuid}/archive/summary/ | GET | auth (VERIFIED+active) | — | 200 summary | not_found |
| search | /minors/{uuid}/search/ | GET | auth (VERIFIED+active) | SearchFilterSerializer | 200 page | not_found |
| documents | /minors/{uuid}/documents/ | GET/POST | auth (VERIFIED+active) | page / multipart | 200 page / 201 doc | not_found |
| doc detail/file/candidates/confirm-date | /minors/{uuid}/documents/{doc}/... | — | auth (VERIFIED+active) | — | — | not_found |

MinorCreateSerializer rules:
- date_of_birth: not future, age < 18 (else patient_not_minor).
- nationality: ISO alpha-2, uppercased.
- document_type: only UNIFIED_NATIONAL_CARD or BIRTH_DOCUMENT.
- LEGAL_GUARDIAN → evidence_file required (relationship_evidence_required).
- evidence_type ↔ evidence_file both-or-neither (validation_error).
- National Card minor: national_number + back_image required, family_number optional.
- front_image required (FileField).

Guardian eligibility (403 guardian_not_verified unless): role PATIENT, ACTIVE, profile exists, adult, identity_status VERIFIED, has CURRENT+VERIFIED UNIFIED_NATIONAL_CARD.

## Documents
| Feature | Endpoint | Method | Auth | Success |
|---|---|---|---|---|
| list | /documents/ | GET | auth | 200 page MedicalDocument |
| detail | /documents/{uuid}/ | GET | auth | 200 detail |
| upload | /documents/ | POST | auth | 201 MedicalDocument |
| file | /documents/{uuid}/file/ | GET | auth | bytes |
| date-candidates | /documents/{uuid}/date-candidates/ | GET | auth | 200 page DateCandidate |
| confirm-date | /documents/{uuid}/confirm-date/ | POST | auth | 200 DocumentDateConfirmationResponse |

## Facilities
| Feature | Endpoint | Method | Auth | Query | Success |
|---|---|---|---|---|---|
| list | /facilities/ | GET | auth | country(2UL), region(≤120), city(≤120), type(choice), active(default true) | 200 page HealthcareFacility |
| detail | /facilities/{uuid}/ | GET | auth | — | 200 facility |

## Archive
| Feature | Endpoint | Method | Auth | Query | Success |
|---|---|---|---|---|---|
| list | /archive/ | GET | auth | ArchiveQuery filters | 200 ArchivePage |
| summary | /archive/summary/ | GET | auth | — | 200 ArchiveSummary |

ArchiveQuerySerializer (verified from archive/serializers.py — see note): year, month, document_type, healthcare_facility, date_status(VERIFIED/UNCONFIRMED), page. **UNCONFIRMED cannot combine with year/month/date_from/date_to.**

## Search
| Feature | Endpoint | Method | Auth | Query | Success |
|---|---|---|---|---|---|
| search | /search/ | GET | auth | q(≤200), date_from, date_to, year(1900-2100), month(1-12, requires year), document_type, healthcare_facility(UUID), department, physician_name, uploaded_from, uploaded_to, date_status(VERIFIED/UNCONFIRMED), page | 200 page ArchiveDocument |

Search rules: month requires year; date_from<=date_to; uploaded_from<=uploaded_to; dates within 1900-01-01..2100-12-31; UNCONFIRMED cannot combine with date_from/date_to/year/month. Throttled (MedicalSearchThrottle).

## Account Claims
| Feature | Endpoint | Method | Auth | Request | Success | Errors |
|---|---|---|---|---|---|---|
| submit | /account-claims/ | POST | public (AllowAny) + throttle | digital_id, email, phone, full_name, date_of_birth, identity_document_type(==UNIFIED_NATIONAL_CARD), identity_document_number, front_image, back_image | 202 {data:{claim_id,status}} | validation_error, throttled |
| activate | /auth/activate-claimed-account/ | POST | public + throttle | token, new_password | 200 {data:{message}} | validation_error, throttled |

Claim rules: phone `^\+?[1-9]\d{7,14}$`; front+back JPEG/PNG; DOB not future.
Receipt is synthetic — UI must use generic "submitted for review" wording.

## BACKEND CONTRACT DEFECTS
- **ACCOUNT_CLAIM_DIGITAL_ID_REGEX**: `claims/serializers.py` requires `^\d{17}$`, but `patients/services.py` generates `PT-XXXX-XXXX-XXXX`. A real Digital ID cannot pass the claim serializer → claim submission cannot be end-to-end PASS until backend fixed. Flutter models canonical `PT-XXXX-XXXX-XXXX`, does NOT transform. See `test/core/account_claim_contract_test.dart` + `docs/account_claim_digital_id_defect.md`.

## Error codes (patient-relevant)
guardian_not_verified(403), patient_not_minor(400), relationship_evidence_required(400), idempotency_key_required(400), invalid_idempotency_key(400), idempotency_conflict(409), validation_error(400), invalid_credentials(401), account_unavailable(401), not_authenticated(401), throttled(429), not_found(404), relationship_transition_conflict(409), authentication_failed(401).
