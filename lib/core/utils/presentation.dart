import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../models/enums.dart';
import '../models/facility.dart';

/// Shared non-localized presentation helpers. Localized labels live in
/// [StatusLabels]; badges live in `status_badge.dart`.

/// Icon for a medical document type. Single source of truth for document
/// type icons across home/documents/archive/search/detail.
IconData documentTypeIcon(MedicalDocumentType t) {
  switch (t) {
    case MedicalDocumentType.laboratory:
      return Icons.science_outlined;
    case MedicalDocumentType.radiology:
      return Icons.medical_information_outlined;
    case MedicalDocumentType.prescription:
      return Icons.medication_outlined;
    case MedicalDocumentType.consultation:
      return Icons.medical_services_outlined;
    case MedicalDocumentType.medicalReport:
      return Icons.description_outlined;
    case MedicalDocumentType.hospitalAdmission:
      return Icons.local_hospital_outlined;
    case MedicalDocumentType.dischargeSummary:
      return Icons.assignment_turned_in_outlined;
    case MedicalDocumentType.surgeryProcedure:
      return Icons.medical_services_outlined;
    case MedicalDocumentType.pathology:
      return Icons.biotech_outlined;
    case MedicalDocumentType.vaccination:
      return Icons.vaccines_outlined;
    case MedicalDocumentType.vitalSigns:
      return Icons.monitor_heart_outlined;
    case MedicalDocumentType.other:
    case MedicalDocumentType.unknown:
      return Icons.insert_drive_file_outlined;
  }
}

/// Preferred facility display name:
/// 1. canonical `healthcareFacility?.name`
/// 2. raw `facilityName`
/// 3. `locationText`
/// 4. empty (caller decides whether to hide).
String facilityDisplayName({
  HealthcareFacility? healthcareFacility,
  String facilityName = '',
  String locationText = '',
}) {
  if (healthcareFacility?.name.trim().isNotEmpty == true) {
    return healthcareFacility!.name.trim();
  }
  if (facilityName.trim().isNotEmpty) return facilityName.trim();
  if (locationText.trim().isNotEmpty) return locationText.trim();
  return '';
}

/// Locale-aware display date for patients (e.g. "17 Sep 2025", Arabic
/// "17 سبتمبر 2025"). Request/API formatting stays `formatApiDate`.
String localizedDate(AppLocalizations l10n, DateTime? date) {
  if (date == null) return '';
  return DateFormat('d MMM y', l10n.localeName).format(date);
}

/// Localized "Needs date confirmation" — used when a document has no
/// usable date.
String dateFallbackLabel(AppLocalizations l10n) => l10n.needsDateConfirmation;

/// Avatar initials from a patient full name: first + last initials.
/// Handles Arabic names without forcing Latin assumptions; falls back to '?'.
String patientInitials(String fullName) {
  final name = fullName.trim();
  if (name.isEmpty) return '?';
  final parts = name.split(RegExp(r'\s+'));
  if (parts.length == 1) {
    final first = parts.first.characters.firstOrNull;
    return (first ?? '?').toUpperCase();
  }
  final a = parts.first.characters.firstOrNull;
  final b = parts.last.characters.firstOrNull;
  if (a == null && b == null) return '?';
  return '${a ?? ''}${b ?? ''}'.toUpperCase();
}

/// Human file size from bytes.
String fileSizeLabel(int? sizeBytes) {
  if (sizeBytes == null || sizeBytes <= 0) return '';
  if (sizeBytes < 1024) return '$sizeBytes B';
  if (sizeBytes < 1024 * 1024) {
    return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
  }
  return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}
