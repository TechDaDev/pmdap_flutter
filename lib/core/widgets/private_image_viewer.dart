import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

/// Shows a private image from authenticated bytes via `Image.memory` —
/// no permanent copy is written to disk or the gallery.
class PrivateImageViewer extends StatelessWidget {
  const PrivateImageViewer({
    super.key,
    required this.title,
    required this.fetchBytes,
  });

  final String title;
  final Future<Uint8List> Function() fetchBytes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<Uint8List>(
        future: fetchBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.errorGeneric));
          }
          final bytes = snapshot.data;
          if (bytes == null) return Center(child: Text(l10n.noData));
          return InteractiveViewer(child: Center(child: Image.memory(bytes)));
        },
      ),
    );
  }
}
