# ADR-0005: Online-first

- Status: Accepted
- Date: 2026-08-10
- Context: The backend is the single source of truth for medical records,
  identity state, and document processing.

## Decision

- The app is online-first: server state is fetched from the backend and never
  mirrored in a local medical-record database. No offline write queue.
- Riverpod providers derive UI state from API calls; list/detail providers are
  invalidated after mutations to refetch from the server.
- Search history, medical text, and identity data are never persisted locally.
- Document processing is polled server-side (detail) every 3 s only while a
  processing state is active, stopping at terminal/actionable states and when
  the app is backgrounded.

## Consequences

- No offline medical records; a dropped connection surfaces a safe
  "network error" state with retry.
