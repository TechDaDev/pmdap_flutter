/// Safe date parsing/formatting helpers (backend uses ISO-8601 YYYY-MM-DD).
library;

/// Parse backend `YYYY-MM-DD` string into a [DateTime] (date-only, local).
///
/// Returns null for null/empty/invalid input rather than throwing.
DateTime? parseApiDate(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value)?.toLocal();
}

/// Parse a backend ISO-8601 datetime string into a [DateTime] (local).
///
/// Returns null for null/empty/invalid input rather than throwing.
DateTime? parseApiDateTime(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value)?.toLocal();
}

/// Format a [DateTime] as backend `YYYY-MM-DD`.
String formatApiDate(DateTime? date) {
  if (date == null) return '';
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Human display for a date-only value, locale-aware (caller supplies [format]).
String formatDisplayDate(DateTime? date, String Function(String pattern) fmt) {
  if (date == null) return '—';
  return fmt('yyyy-MM-dd');
}

/// Human age string from a date of birth.
String ageFromDob(DateTime? dob, {DateTime? now}) {
  if (dob == null) return '';
  final ref = now ?? DateTime.now();
  var age = ref.year - dob.year;
  final monthDiff = ref.month - dob.month;
  if (monthDiff < 0 || (monthDiff == 0 && ref.day < dob.day)) {
    age--;
  }
  if (age < 0) age = 0;
  return '$age';
}
