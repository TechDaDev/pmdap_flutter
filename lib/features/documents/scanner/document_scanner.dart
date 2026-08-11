import 'package:flutter/services.dart';

/// Result of a Google ML Kit document scan (Android).
class DocumentScanResult {
  const DocumentScanResult({
    required this.pagePaths,
    this.pdfPath,
    this.pageCount = 0,
  });

  /// Absolute paths to per-page JPEGs in the app-private cache.
  final List<String> pagePaths;

  /// Absolute path to the combined PDF, when produced (multi-page).
  final String? pdfPath;

  final int pageCount;

  bool get cancelled => pagePaths.isEmpty && pdfPath == null;

  bool get isEmpty => pagePaths.isEmpty && pdfPath == null;
}

/// Scanner unavailable / unsupported / plugin missing (e.g. non-Android).
class ScannerUnavailableException implements Exception {
  const ScannerUnavailableException([
    this.message = 'Document scanner unavailable',
  ]);
  final String message;
  @override
  String toString() => 'ScannerUnavailableException: $message';
}

const MethodChannel _scannerChannel = MethodChannel('pmdap/document_scanner');

/// Launches the on-device Google Play services document scanner.
///
/// Throws [ScannerUnavailableException] when the platform cannot start it.
/// A user cancellation returns a result with [DocumentScanResult.cancelled].
Future<DocumentScanResult> scanDocument() async {
  try {
    final map = await _scannerChannel.invokeMapMethod<String, dynamic>('scan');
    if (map == null || map['cancelled'] == true) {
      return const DocumentScanResult(pagePaths: [], pageCount: 0);
    }
    final pages = (map['pages'] as List? ?? const []).cast<String>();
    return DocumentScanResult(
      pagePaths: pages,
      pdfPath: map['pdf'] as String?,
      pageCount: (map['pageCount'] as num?)?.toInt() ?? pages.length,
    );
  } on PlatformException catch (e) {
    if (e.code == 'busy') {
      throw const ScannerUnavailableException('Scanner already running');
    }
    throw ScannerUnavailableException(
      e.message ?? 'Document scanner unavailable',
    );
  } on MissingPluginException {
    throw const ScannerUnavailableException(
      'Scanner not supported on this platform',
    );
  }
}
