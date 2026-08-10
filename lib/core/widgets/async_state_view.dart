import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../api/api_exception.dart';
import 'error_view.dart';

/// Renders a Riverpod [AsyncValue] with loading / error / data states.
/// Errors always show safe, user-friendly text (never raw exceptions).
class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    super.key,
    required this.value,
    required this.builder,
    this.onRetry,
    this.loadingMessage,
    this.emptyBuilder,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;
  final String? loadingMessage;

  /// Returns an empty-state widget when [data] qualifies, or null to build.
  final Widget? Function(T data)? emptyBuilder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: (data) {
        final empty = emptyBuilder?.call(data);
        if (empty != null) return empty;
        return builder(data);
      },
      loading: () => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (loadingMessage != null) ...[
              const SizedBox(height: 12),
              Text(loadingMessage!),
            ],
          ],
        ),
      ),
      error: (error, _) =>
          ErrorView(message: _safeMessage(context, error), onRetry: onRetry),
    );
  }

  String _safeMessage(BuildContext context, Object error) {
    if (error is ApiException) return error.message;
    return AppLocalizations.of(context).errorGeneric;
  }
}
