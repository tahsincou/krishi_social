import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const _key = 'locale';

  Future<Locale> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);

    if (code == null) {
      return const Locale('en');
    }

    return Locale(code);
  }

  Future<void> save(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}
