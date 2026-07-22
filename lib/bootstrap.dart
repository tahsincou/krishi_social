import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/app.dart';
import 'package:krishi_social/core/config/app_config.dart';
import 'package:krishi_social/core/config/supabse_config.dart';
import 'package:krishi_social/core/services/environment_service.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
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

  final container = ProviderContainer();

  await container.read(authNotifierProvider.notifier).checkLogin();

  final authState = container.read(authNotifierProvider);

  if (authState.isAuthenticated) {
    await container.read(feedNotifierProvider.notifier).initialize();
  }

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
