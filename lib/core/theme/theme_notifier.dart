import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_mvp_starter/core/services/theme_service.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(this._service) : super(ThemeMode.system) {
    load();
  }

  final ThemeService _service;

  Future<void> load() async {
    state = await _service.load();
  }

  Future<void> change(ThemeMode mode) async {
    state = mode;
    await _service.save(mode);
  }
}
