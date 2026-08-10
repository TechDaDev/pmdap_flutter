import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// App entry point.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PmdapApp()));
}
