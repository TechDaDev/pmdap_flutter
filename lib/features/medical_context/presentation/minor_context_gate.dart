import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../l10n/app_localizations.dart';
import '../application/patient_context_controller.dart';

class MinorContextGate extends ConsumerStatefulWidget {
  const MinorContextGate({
    super.key,
    required this.minorUuid,
    required this.destination,
  });

  final String minorUuid;
  final String destination;

  @override
  ConsumerState<MinorContextGate> createState() => _MinorContextGateState();
}

class _MinorContextGateState extends ConsumerState<MinorContextGate> {
  late final Future<bool> _authorization;

  @override
  void initState() {
    super.initState();
    _authorization = ref
        .read(patientContextControllerProvider.notifier)
        .enterByMinorUuid(widget.minorUuid);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
    future: _authorization,
    builder: (context, snapshot) {
      if (snapshot.data == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) ref.read(routerProvider).go(widget.destination);
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (snapshot.connectionState != ConnectionState.done) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              AppLocalizations.of(context).accessNoLongerActive,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    },
  );
}
