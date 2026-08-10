# ADR-0004: Private file handling

- Status: Accepted
- Date: 2026-08-10
- Context: Identity images and original medical files are private. The backend
  serves them only through authenticated endpoints with
  `Cache-Control: private, no-store` and IDOR-safe 404s; there are no public
  file URLs.

## Decision

- Private files are fetched with the authenticated `Authorization` header only.
- Identity images are rendered in-memory via `Image.memory` — never written to
  disk or the gallery.
- Medical files (e.g. PDFs) are downloaded into the app's temporary directory
  only when a real file is needed for viewing (`PrivateMediaCache`), opened
  with `open_filex`, then cleaned up. Nothing is saved to public Downloads or
  the gallery automatically.
- No raw OCR/native extracted text is displayed or persisted.

## Consequences

- Temporary private copies are best-effort deleted after viewing.
- No `CAMERA` permission or capture is implemented in this milestone.
