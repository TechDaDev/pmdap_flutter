import 'dart:math';

/// Cryptographically-adequate random UUID v4 (RFC 4122) without external deps.
///
/// Used for the guardian minor-creation `Idempotency-Key` so a retry of the
/// same unchanged form reuses the same key (backend replays) while a new
/// logical submission gets a fresh key.
String generateUuidV4() {
  final rnd = Random.secure();
  final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
  // RFC 4122 v4: variant + version bits.
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  String hex(int b) => b.toRadixString(16).padLeft(2, '0');
  return '${hex(bytes[0])}${hex(bytes[1])}${hex(bytes[2])}${hex(bytes[3])}-'
      '${hex(bytes[4])}${hex(bytes[5])}-'
      '${hex(bytes[6])}${hex(bytes[7])}-'
      '${hex(bytes[8])}${hex(bytes[9])}-'
      '${hex(bytes[10])}${hex(bytes[11])}${hex(bytes[12])}'
      '${hex(bytes[13])}${hex(bytes[14])}${hex(bytes[15])}';
}

/// Holds the stable idempotency key for one logical minor-creation submission.
///
/// Rules:
/// - `keyForSubmission()` returns the SAME key across retries of the same
///   unchanged form (network timeouts, temporary 5xx user retries).
/// - `noteContentChanged()` clears the key so materially different content
///   becomes a new logical submission.
/// - `reset()` clears the key after a successful submission (new child).
class IdempotencyKeyManager {
  IdempotencyKeyManager({String Function()? generate})
    : _generate = generate ?? generateUuidV4;

  final String Function() _generate;
  String? _key;

  /// Current stable key, or null before the first submission starts.
  String? get current => _key;

  /// Returns the stable key for the current logical submission, creating it
  /// on first use.
  String keyForSubmission() => _key ??= _generate();

  /// Form content changed after an attempt — invalidate so the next
  /// submission is a new logical request with a fresh key.
  void noteContentChanged() => _key = null;

  /// Successful submission / form reset — start a new logical submission.
  void reset() => _key = null;
}
