import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/patient/application/patient_providers.dart';
import '../utils/presentation.dart';

/// Reusable authenticated patient avatar.
///
/// - No `avatarUrl` → initials fallback.
/// - `avatarUrl` set → loads private bytes via [patientAvatarProvider]
///   (authenticated Dio fetch, in-memory cached) and shows the image.
/// - Loading, 404, 503 or network failure → initials fallback, never a
///   broken-image icon or a crash.
///
/// Never uses `Image.network` (would bypass auth and require a public URL).
class PatientAvatar extends ConsumerWidget {
  const PatientAvatar({
    super.key,
    required this.fullName,
    this.avatarUrl,
    this.radius = 20,
    this.onTap,
    this.semanticLabel,
  });

  final String fullName;
  final String? avatarUrl;
  final double radius;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bytes = avatarUrl == null
        ? null
        : ref.watch(patientAvatarProvider).valueOrNull;
    final label = semanticLabel ?? '';
    final semantics = Semantics(
      label: label.isEmpty ? fullName : label,
      image: bytes != null,
      child: _content(context, bytes),
    );
    if (onTap == null) return semantics;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: semantics,
    );
  }

  Widget _content(BuildContext context, Uint8List? bytes) {
    if (bytes != null && bytes.isNotEmpty) {
      return ClipOval(
        child: Image.memory(
          bytes,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          cacheWidth: 256,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => _initials(context),
        ),
      );
    }
    return _initials(context);
  }

  Widget _initials(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      child: Text(
        patientInitials(fullName),
        style: TextStyle(
          fontSize: radius * 0.72,
          fontWeight: FontWeight.w600,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
