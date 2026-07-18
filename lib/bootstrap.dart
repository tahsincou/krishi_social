import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/app.dart';
import 'package:krishi_social/core/config/app_config.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.initialize();

  runApp(const ProviderScope(child: App()));
}
