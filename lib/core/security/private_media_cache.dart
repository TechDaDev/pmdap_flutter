import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Private medical/identity files are fetched through authenticated endpoints
/// and cached ONLY in the app's temporary directory when a real file is needed
/// (e.g. opening a PDF). Clean up after use. Never save to public Downloads or
/// the gallery.
class PrivateMediaCache {
  PrivateMediaCache._();

  static Future<File> cacheBytes(Uint8List bytes, String filename) async {
    final dir = await getTemporaryDirectory();
    final safe = filename.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final file = File('${dir.path}/pmdap_$safe');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<void> cleanup(File file) async {
    try {
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Best-effort cleanup.
    }
  }
}
