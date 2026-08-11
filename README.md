# PMDAP Mobile (pre-camera stage)

Patient Medical Document Archiving Platform — Flutter mobile client.

By default the app targets the **deployed backend** at
`https://pmdapbackend.up.railway.app/api/v1` (HTTPS). A local Django backend
at `/api/v1/` is supported through a build-time override for development.
> (gallery/file picker). Camera capture is NOT implemented yet and is the next
> explicitly approved milestone.

## Features (implemented)

- Session bootstrap (splash → refresh → `/auth/me/`)
- Login / registration (backend creates User + PatientProfile + Digital ID)
- Home dashboard (patient, Digital ID, identity state, unconfirmed dates,
  recent documents)
- Profile (read-only verified fields, backend-approved editable fields, logout)
- Identity documents: choose existing image → submit → list/history → detail →
  private image view → replace (no camera)
- Minors (guardian): list, create (multipart + `Idempotency-Key`), detail,
  minor-scoped documents/archive/search
- Medical documents: upload existing PDF/JPEG/PNG, list, detail with processing
  polling (3 s while active), private file viewing, soft delete, date
  candidates + confirmation (candidate or manual `YYYY-MM-DD`)
- Facilities: read-only searchable selector
- Archive: chronological list + year/type/date-status filters
- Search: lexical backend search (never logged/persisted)
- Account claim entry point (public submission)
- Development health diagnostics (debug builds only)

## Architecture

Feature-first clean architecture (`lib/app`, `lib/core`, `lib/features/*`).
See `docs/architecture/` ADRs 0001–0006.

- State: Riverpod (`Notifier`/`FutureProvider`/providers)
- Router: `go_router` with auth-gated redirect
- HTTP: `dio` — one centralized client, backend error-envelope mapper,
  single-flight token refresh with one-time retry
- Secure storage: `flutter_secure_storage` (refresh token only; access token in
  memory)
- DTOs: `freezed` + `json_serializable` (enums preserve exact backend strings)
- i18n: `flutter gen-l10n` (English complete, Arabic primary strings, RTL-safe
  layouts)

## Flutter / Android setup

- Flutter 3.41.7 stable, Dart 3.11.5
- Android SDK at `$ANDROID_HOME` (platform 36, build-tools 36.1.0)
- JDK 17 configured for Gradle:
  `flutter config --jdk-dir=/usr/lib/jvm/java-17-openjdk-amd64`
- Package id: `com.pmdap.mobile`; app name **PMDAP**

## Local backend startup

```bash
cd /path/to/pmdap_backend
docker compose up -d            # db + redis + web + worker
curl http://localhost:8000/api/v1/health/   # -> {"status":"ok"}
```

Live OpenAPI schema: `GET http://localhost:8000/api/v1/schema/`.

## LAN networking

The phone cannot use `localhost:8000`. Determine the workstation LAN IP:

```bash
hostname -I        # e.g. 192.168.88.20
```

The backend publishes port 8000 on all interfaces (`0.0.0.0`). For local LAN
development add the LAN IP to the dev-only backend env (gitignored `.env`):

```
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,192.168.88.20
```

then `docker compose up -d --force-recreate web`. Do not weaken production
settings; do not use `ALLOWED_HOSTS=*`. Verify from the phone:

```
GET http://192.168.88.20:8000/api/v1/health/
```

## API base URL

The default target is the deployed Railway backend:

```
https://pmdapbackend.up.railway.app/api/v1
```

No override is needed for online use — just build/run normally.

### Local override

For a local backend pass the LAN base at run/build time — never hard-code an
IP:

```bash
flutter run -d <device> \
  --dart-define=PMDAP_API_BASE_URL=http://192.168.88.20:8000/api/v1
```

Both forms behave identically regarding trailing slash — a trailing `/` is
normalized so path joins never produce `//`.

### HTTPS policy

Online mode always uses HTTPS with normal TLS validation (no bypass, no
certificate trust override). Debug builds additionally allow cleartext HTTP to
the LAN backend (`android/app/src/debug/AndroidManifest.xml`). Release builds
keep cleartext disabled — HTTPS only.

## Physical-device testing

USB is only for install/debug. The phone connects to Railway over normal
internet — it does not depend on `localhost`, LAN IPs, or USB port forwarding:

```bash
flutter run -d <device-id>                     # online (Railway default)
flutter run -d <device-id> \
  --dart-define=PMDAP_API_BASE_URL=http://<LAN-IP>:8000/api/v1   # local
```

Use an **owner-provided test account** to sign in on the device (never commit
credentials).

## ADB phone setup

```bash
adb devices -l
# if "unauthorized": accept the USB debugging prompt on the phone, then retry
flutter devices
```

## Test commands

```bash
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test test/core test/widgets          # 70 unit + widget tests
flutter test integration_test -d linux       # mocked end-to-end flows (Linux desktop)
```

Real-backend smoke (synthetic data only; login-first to avoid the 5/hour
register throttle). Create the synthetic account once, then pass credentials
via env:

```bash
# create once (register is throttled to 5/hour per IP):
curl -X POST http://localhost:8000/api/v1/auth/register/ \
  -H 'Content-Type: application/json' \
  -d '{"email":"pmdap_smoke@example.com","password":"<dev-pass>","patient":{"full_name":"PMDAP Smoke","date_of_birth":"1992-04-05","sex":"MALE","nationality":"IQ"}}'

# run smoke:
PMDAP_SMOKE_EMAIL=pmdap_smoke@example.com \
PMDAP_SMOKE_PASSWORD='<dev-pass>' \
PMDAP_API_BASE_URL=http://192.168.88.20:8000/api/v1 \
  dart run tool/smoke.dart
```

## Debug APK build + install

```bash
flutter build apk --debug                                   # online (Railway)
flutter build apk --debug \
  --dart-define=PMDAP_API_BASE_URL=http://192.168.88.20:8000/api/v1   # local
# artifact: build/app/outputs/flutter-apk/app-debug.apk

adb install -r build/app/outputs/flutter-apk/app-debug.apk
# or
flutter install -d <device-id>
```

## Known Railway OCR limitation

PaddleOCR CPU inference on the deployed Railway hardware (AVX-512) currently
returns **zero text detections**. Consequences for online processing:

- **Native-text PDFs** (embedded text layer): work — extraction and date
  candidates succeed.
- **Scanned/image-only documents** requiring OCR: may fail server-side with an
  OCR-required/processing failure state.

The Flutter app does not perform client-side OCR, does not endlessly retry,
and displays the backend failure state safely. This is a backend deployment
limitation, not a mobile bug.

No production signing keys are created in this milestone; a signed release APK
is a later step.

## Known limitations

- No camera capture (approved next milestone).
- No offline mode (online-first).
- Identity verification requires backend agent state; guardian access uses
  backend authorization.
- Arabic translations cover primary strings; full medical/legal wording is
  deferred.
- iOS builds are possible from this codebase but require macOS/Xcode.

## Security review checklist (implemented)

- Refresh token only in secure storage; access token in memory; never logged.
- No medical/identity/OCR/search content logged or persisted.
- Cleartext HTTP only in debug; release is HTTPS-only.
- No hardcoded test passwords in committed code; backend secrets not included.
- No admin / verification-agent / doctor features in the patient app.
