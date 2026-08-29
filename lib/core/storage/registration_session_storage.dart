import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Resume record for an M31B registration email session.
///
/// Only non-secret data is persisted: the capability session token and the
/// account fields. The password is NEVER stored — it stays in memory only and
/// is re-entered after an app restart. Verification state is authoritative
/// server-side, so this record is only a capability to resume it.
class RegistrationSessionRecord {
  const RegistrationSessionRecord({
    required this.sessionToken,
    required this.email,
    this.phone = '',
    this.governorate = '',
  });

  final String sessionToken;
  final String email;
  final String phone;
  final String governorate;

  Map<String, dynamic> toJson() => {
    'session_token': sessionToken,
    'email': email,
    'phone': phone,
    'governorate': governorate,
  };

  factory RegistrationSessionRecord.fromJson(Map<String, dynamic> json) {
    return RegistrationSessionRecord(
      sessionToken: (json['session_token'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      governorate: (json['governorate'] as String?) ?? '',
    );
  }
}

/// Abstraction over where the registration session capability lives, so tests
/// can use an in-memory fake.
abstract class RegistrationSessionStorage {
  Future<RegistrationSessionRecord?> read();
  Future<void> write(RegistrationSessionRecord record);
  Future<void> clear();
}

/// Secure storage-backed implementation (Keychain/Keystore).
class SecureRegistrationSessionStorage implements RegistrationSessionStorage {
  SecureRegistrationSessionStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _key = 'pmdap_registration_session';

  @override
  Future<RegistrationSessionRecord?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return RegistrationSessionRecord.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(RegistrationSessionRecord record) =>
      _storage.write(key: _key, value: jsonEncode(record.toJson()));

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
