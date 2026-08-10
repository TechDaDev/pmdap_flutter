import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/session_controller.dart';

/// Session bootstrap: shows a branded spinner while [restoreSession] resolves.
/// The router redirects away as soon as auth state becomes known, so protected
/// content never flashes before authentication resolves.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionControllerProvider.notifier).restoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.health_and_safety_outlined,
              size: 64,
              color: AppTheme.light().colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('PMDAP', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}
