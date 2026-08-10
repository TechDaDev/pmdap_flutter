# ADR-0001: Flutter mobile client architecture

- Status: Accepted
- Date: 2026-08-10
- Context: First installable PMDAP mobile app, pre-camera stage, against the
  frozen Django backend at `/api/v1/`.

## Decision

Feature-first clean architecture:

- `lib/app/` — composition root: `bootstrap`, `app`, `router`, shell.
- `lib/core/` — cross-cutting: `api` (Dio client, error mapper, interceptors),
  `auth` (token store + single-flight refresh), `config`, `constants`,
  `models` (DTOs), `security` (private-file cache), `storage` (secure refresh
  token), `theme`, `utils`, `widgets` (reusable components).
- `lib/features/<feature>/` — `data` (Dio-backed APIs), `application`
  (Riverpod providers), `presentation` (screens).

No repository/use-case layers are added for trivial operations. API boundaries
mirror the backend contract exactly; each feature talks to one API service.

## Consequences

- Backend API boundaries are obvious and testable with provider overrides.
- Camera capture will slot into the `identity`/`documents` features cleanly
  (data layer already separates "existing file" submission).
