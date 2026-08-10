import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';

import '../../../core/config/app_config.dart';

/// Development diagnostics: verifies backend health over the configured base
/// URL. Shows base host + HTTP status only — never credentials or internals.
class DevHealthScreen extends ConsumerStatefulWidget {
  const DevHealthScreen({super.key});

  @override
  ConsumerState<DevHealthScreen> createState() => _DevHealthScreenState();
}

class _DevHealthScreenState extends ConsumerState<DevHealthScreen> {
  late Future<int?> _future;

  @override
  void initState() {
    super.initState();
    _future = _check();
  }

  Future<int?> _check() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );
    try {
      final resp = await dio.get<dynamic>('/health/');
      return resp.statusCode;
    } on DioException catch (e) {
      return e.response?.statusCode;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.healthCheck)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(l10n.apiBaseHost),
              subtitle: Text(AppConfig.apiBaseUrl),
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<int?>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Card(
                  child: ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text('…'),
                  ),
                );
              }
              final status = snapshot.data;
              final reachable = status != null && status < 500;
              return Card(
                child: ListTile(
                  leading: Icon(
                    reachable ? Icons.check_circle : Icons.error_outline,
                    color: reachable
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  title: Text(
                    reachable ? l10n.healthReachable : l10n.healthUnreachable,
                  ),
                  subtitle: Text('${l10n.httpStatus}: ${status ?? '—'}'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
