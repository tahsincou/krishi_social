import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_mvp_starter/core/services/theme_service.dart';
import 'package:flutter_mvp_starter/core/theme/theme_notifier.dart';

final themeServiceProvider = Provider((ref) => ThemeService());

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((
  ref,
) {
  return ThemeNotifier(ref.read(themeServiceProvider));
});
