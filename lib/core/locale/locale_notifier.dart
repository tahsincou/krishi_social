import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_mvp_starter/core/services/locale_service.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._service) : super(const Locale('en')) {
    load();
  }

  final LocaleService _service;

  Future<void> load() async {
    state = await _service.load();
  }

  Future<void> change(String languageCode) async {
    final locale = Locale(languageCode);
    state = locale;
    await _service.save(locale);
  }
}
