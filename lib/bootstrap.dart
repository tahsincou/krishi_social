import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvp_starter/core/app.dart';
import 'package:flutter_mvp_starter/core/config/app_config.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.initialize();

  runApp(const ProviderScope(child: App()));
}
