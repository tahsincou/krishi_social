import 'package:shared_preferences/shared_preferences.dart';

class EnvironmentService {
  static const _key = 'app_environment';

  static const demo = 'demo';
  static const staging = 'staging';

  static Future<void> save(String environment) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, environment);
  }

  static Future<String> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? demo;
  }

  static Future<bool> isDemo() async {
    return await load() == demo;
  }

  static Future<bool> isStaging() async {
    return await load() == staging;
  }
}
