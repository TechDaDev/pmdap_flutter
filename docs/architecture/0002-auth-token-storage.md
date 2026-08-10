# ADR-0002: Auth token storage

- Status: Accepted
- Date: 2026-08-10
- Context: Backend issues short-lived access tokens (5 min) and refresh tokens
  (1 day) with rotation (`ROTATE_REFRESH_TOKENS`, `BLACKLIST_AFTER_ROTATION`).

## Decision

- Refresh token → platform secure storage only (`flutter_secure_storage`,
  Keystore/Keychain). Never SharedPreferences, never plain files.
- Access token → memory only (`TokenStore.accessToken`); never persisted.
- Single-flight refresh via `TokenRefresher`: at most one refresh request at a
  time; concurrent 401 callers share the in-flight future; tokens updated
  atomically; on failure tokens are cleared and the session is invalidated.
- `RefreshInterceptor` retries an eligible 401 exactly once. Auth endpoints
  (login/register/refresh/activate) never trigger refresh. `pmdap_retried` flag
  prevents refresh loops.
- No passwords, medical/OCR/identity text, or search history are persisted.

## Consequences

- `flutter_secure_storage` 10.x is used (11.x conflicts with modern
  `file_picker` on Windows win32; Android/iOS behavior is unchanged).
