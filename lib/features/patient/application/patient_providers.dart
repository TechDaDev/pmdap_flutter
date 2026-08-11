import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/patient.dart';
import '../../auth/application/session_controller.dart';

/// Current patient profile. Auth-gated so logout/account change invalidates it
/// automatically (provider recomputes when [authStateProvider] changes) — the
/// next account never sees the previous user's cached data.
final patientProfileProvider = FutureProvider.autoDispose<PatientProfile>((
  ref,
) async {
  final auth = ref.watch(authStateProvider);
  if (auth is! AuthAuthenticated) {
    throw const ApiException(
      code: 'not_authenticated',
      message: 'Not signed in.',
    );
  }
  return ref.watch(patientApiProvider).me();
});

/// Authenticated private avatar bytes, in-memory cached.
///
/// - Returns `null` when the profile has no avatar, when the fetch fails
///   (404/503/network), or when signed out — UI falls back to initials.
/// - Recomputes automatically when the profile changes (upload/remove) because
///   it watches [patientProfileProvider].
/// - Recomputes on auth change (login/logout/account switch) because it
///   watches [authStateProvider].
final patientAvatarProvider = FutureProvider.autoDispose<Uint8List?>((ref) {
  final auth = ref.watch(authStateProvider);
  if (auth is! AuthAuthenticated) return Future.value(null);
  return _loadAvatar(ref);
});

Future<Uint8List?> _loadAvatar(Ref ref) async {
  final profile = await ref.watch(patientProfileProvider.future);
  if (profile.avatarUrl == null) return null;
  try {
    return await ref.watch(patientApiProvider).fetchAvatar();
  } on ApiException {
    return null; // 404/503/401 — initials fallback, never crash the screen.
  } catch (_) {
    return null;
  }
}
