import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/di/providers.dart';
import '../../../core/models/date_candidate.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/buttons.dart';
import '../../documents/application/documents_providers.dart';

/// Date candidate selection + manual YYYY-MM-DD correction.
/// The backend owns `date_source`/`date_verified` — the client never sets them.
class DateConfirmationScreen extends ConsumerStatefulWidget {
  const DateConfirmationScreen({
    super.key,
    required this.documentUuid,
    this.minorUuid,
  });

  final String documentUuid;
  final String? minorUuid;

  @override
  ConsumerState<DateConfirmationScreen> createState() =>
      _DateConfirmationScreenState();
}

class _DateConfirmationScreenState
    extends ConsumerState<DateConfirmationScreen> {
  Future<dynamic>? _future;
  DateTime? _manualDate;
  bool _confirming = false;
  String? _errorMessage;

  bool get _isMinor => widget.minorUuid != null;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<dynamic> _load() {
    if (_isMinor) {
      return ref
          .read(minorDocumentsApiProvider)
          .dateCandidates(widget.minorUuid!, widget.documentUuid);
    }
    return ref.read(documentsApiProvider).dateCandidates(widget.documentUuid);
  }

  void _reload() => setState(() => _future = _load());

  Future<void> _confirmCandidate(DateCandidate c) {
    return _confirm(candidateId: c.uuid);
  }

  Future<void> _confirm({String? candidateId}) async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _confirming = true;
      _errorMessage = null;
    });
    try {
      if (_isMinor) {
        await ref
            .read(minorDocumentsApiProvider)
            .confirmDate(
              widget.minorUuid!,
              widget.documentUuid,
              candidateId: candidateId,
              date: candidateId == null ? _manualDate : null,
            );
      } else {
        await ref
            .read(documentsApiProvider)
            .confirmDate(
              widget.documentUuid,
              candidateId: candidateId,
              date: candidateId == null ? _manualDate : null,
            );
      }
      ref.invalidate(documentDetailProvider(widget.documentUuid));
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.dateConfirmed)));
      Navigator.of(context).maybePop();
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = l10n.confirmFailed);
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  Future<void> _pickManualDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _manualDate ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: AppLocalizations.of(context).manualDate,
    );
    if (picked != null) setState(() => _manualDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.confirmDate)),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.errorGeneric),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: _reload, child: Text(l10n.retry)),
                  ],
                ),
              ),
            );
          }
          final page = snapshot.data as dynamic;
          final candidates =
              (page.results as List<DateCandidate>?) ?? const <DateCandidate>[];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                l10n.chooseCandidate,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (candidates.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.noResults),
                )
              else
                for (final c in candidates)
                  Card(
                    child: ListTile(
                      onTap: () => _confirmCandidate(c),
                      leading: Icon(
                        c.isSuggested
                            ? Icons.star
                            : Icons.event_available_outlined,
                        color: c.isSuggested
                            ? Theme.of(context).colorScheme.tertiary
                            : null,
                      ),
                      title: Text(
                        c.date == null ? '—' : formatApiDate(c.date),
                        style: c.isSuggested
                            ? const TextStyle(fontWeight: FontWeight.bold)
                            : null,
                      ),
                      subtitle: Text(
                        [
                          if (c.type.isNotEmpty) c.type,
                          if (c.pageNumber > 0)
                            '${l10n.pageNumber} ${c.pageNumber}',
                          '${l10n.candidateScore}: ${c.score.toStringAsFixed(2)}',
                          if (c.ambiguous) l10n.ambiguousDate,
                        ].join(' · '),
                      ),
                      trailing: const Icon(Icons.check_circle_outline),
                    ),
                  ),
              const Divider(height: 40),
              Text(
                l10n.manualDate,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickManualDate,
                icon: const Icon(Icons.edit_calendar_outlined),
                label: Text(
                  _manualDate == null
                      ? l10n.manualDate
                      : formatApiDate(_manualDate),
                ),
              ),
              if (_manualDate != null) ...[
                const SizedBox(height: 12),
                PrimaryButton(
                  label: l10n.confirmDate,
                  onPressed: _confirming ? null : () => _confirm(),
                  loading: _confirming,
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
