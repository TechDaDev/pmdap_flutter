# Document Scanner — Architecture Decision

## Decision

Use a thin Android platform-channel bridge to Google's ML Kit **Document
Scanner** (`GmsDocumentScanning`, `com.google.android.gms:play-services-mlkit-document-scanner`),
not a third-party Flutter "scanner" plugin.

## Why

- ML Kit Document Scanner = Google Play services scanner UI: viewfinder, edge
  detection, auto/assisted capture, crop, perspective + rotation correction,
  user review, retake, additional pages.
- Scanner runs fully on-device; no cloud upload.
- **No `CAMERA` permission required** — the Play services UI owns the camera.
  PMDAP never requests `android.permission.CAMERA`.
- Multi-page supported: returns page JPEGs + a combined PDF via
  `GmsDocumentScanningResult`.
- Thin native bridge (one `MethodChannel`, `pmdap/document_scanner`) is
  smaller + more auditable than a large unmaintained Flutter dependency.

## Contract

- `MethodChannel('pmdap/document_scanner')` — `scan`.
- Result map:
  - `pages: List<String>` — app-private cache JPEG paths (per page)
  - `pdf: String?` — app-private cache PDF path (multi-page)
  - `pageCount: int`
  - `cancelled: true` on user cancel
- Failure → `PlatformException(code: 'unavailable')` → Flutter shows
  `ScannerUnavailableException` → fallback to "Choose existing file".

## Result handling

- PMDAP uploads the scanner PDF (preferred) or the single page JPEG as one
  `MedicalDocument` through the existing authenticated multipart endpoint.
- No medical OCR/classification on-device; backend remains processing authority.

## Privacy

- Scanner output copied only into the app-private cache; never Gallery,
  Downloads, logs, or third-party cloud. Cleaned when upload/cancel completes.

## Known limitation

- "Add page" across separate scanner sessions is not merged (a new session
  replaces the previous scan). Multi-page capture happens within one scanner
  session (page limit 20). Rescan replaces.

## Facility pagination caveat

- Backend `FacilityFilterSerializer` rejects `page` → first-page request omits
  `page=1`; pagination stays blocked until backend fix
  (`FACILITY_FILTER_REJECTS_PAGE`).
