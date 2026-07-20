import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/app.dart';
import 'package:krishi_social/core/config/app_config.dart';
import 'package:krishi_social/core/config/environment.dart';
import 'package:krishi_social/core/config/supabse_config.dart';
import 'package:krishi_social/core/services/environment_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.initialize();

  if (await EnvironmentService.isStaging()) {
    debugPrint('Supabase URL: ${SupabaseConfig.url}');

    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  }

  runApp(const ProviderScope(child: App()));
}
