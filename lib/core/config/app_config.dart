import 'package:krishi_social/core/config/environment.dart';
import 'package:krishi_social/core/config/supabse_config.dart';
import 'package:path/path.dart';

import '../services/environment_service.dart';

class AppConfig {
  static Environment _environment = Environment.demo;

  static Future<void> initialize() async {
    final env = await EnvironmentService.load();

    _environment = Environment.values.firstWhere(
      (e) => e.name == env,
      orElse: () => Environment.demo,
    );
  }

  static bool get isDemo => _environment == Environment.demo;

  static Environment get environment => _environment;

  static String get baseUrl {
    switch (_environment) {
      case Environment.demo:
        return 'http://192.168.1.105:3001';

      case Environment.development:
        return 'https://dev-api.company.com';

      case Environment.staging:
        return '${SupabaseConfig.url}/rest/v1';

      case Environment.production:
        return 'https://api.company.com';
    }
  }

  static Future<void> changeEnvironment(Environment env) async {
    _environment = env;

    await EnvironmentService.save(env.name);
  }
}
