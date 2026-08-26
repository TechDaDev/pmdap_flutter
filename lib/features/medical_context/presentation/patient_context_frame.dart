import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../app/router.dart';
import '../../auth/application/session_controller.dart';
import '../../archive/application/archive_providers.dart';
import '../../documents/application/documents_providers.dart';
import '../../search/application/search_providers.dart';
import '../application/patient_context_controller.dart';
import '../domain/patient_context.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Global, persistent child-context indicator. It wraps the navigator, so
/// home/archive/search/detail/upload/viewer/date/page/profile cannot lose the
/// selected-patient warning while child records are active.
class PatientContextFrame extends ConsumerWidget {
  const PatientContextFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(sessionControllerProvider, (_, next) {
      if (next is AuthUnauthenticated) {
        ref
            .read(patientContextControllerProvider.notifier)
            .exit(reason: PatientContextExitReason.signedOut);
      }
    });
    ref.listen(patientContextControllerProvider, (previous, next) {
      final wasMinor = previous?.context.isMinor == true;
      if (!wasMinor || next.context.isMinor) return;
      _invalidateExitedChild(ref, previous!.context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(routerProvider).go(Routes.home);
        if (next.exitReason == PatientContextExitReason.accessLost) {
          final l10n = AppLocalizations.of(context);
          rootScaffoldMessengerKey.currentState
            ?..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.accessNoLongerActive)));
        }
      });
    });

    final patientContext = ref.watch(patientContextProvider);
    if (!patientContext.isMinor) return child;
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = patientContext.safeDisplayName ?? '';
    return Column(
      children: [
        Material(
          color: colorScheme.secondaryContainer,
          child: SafeArea(
            bottom: false,
            child: Semantics(
              container: true,
              label: '${l10n.viewingRecordsFor} $displayName.',
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 8, 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.family_restroom_outlined,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${l10n.viewingRecordsFor}\n$displayName',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => ref
                          .read(patientContextControllerProvider.notifier)
                          .exit(),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(l10n.backToMyRecords),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

void _invalidateExitedChild(WidgetRef ref, PatientContext childContext) {
  final archiveScope = ArchiveScope.minor(childContext.minorUuid!);
  ref.invalidate(contextDocumentsProvider(childContext));
  ref.invalidate(contextPendingDateConfirmationDocumentsProvider(childContext));
  ref.invalidate(archiveProvider(archiveScope));
  ref.invalidate(archiveSummaryProvider(archiveScope));
  ref.invalidate(archiveFilterProvider(childContext.cacheKey));
  ref.invalidate(contextSearchResultsProvider(childContext));
  ref.invalidate(contextSearchQueryProvider(childContext.cacheKey));

  // Detail/page families may contain several document UUIDs and page numbers.
  // Clearing the families ensures no revoked child's last-good payload remains
  // available after the context exits.
  ref.invalidate(contextDocumentDetailProvider);
  ref.invalidate(contextLabResultsProvider);
  ref.invalidate(contextExtractedContentProvider);
  ref.invalidate(contextDateCandidatesProvider);
  ref.invalidate(contextDocumentPagesProvider);
  ref.invalidate(contextDocumentPageDetailProvider);
  ref.invalidate(contextDocumentPageLabResultsProvider);
}
