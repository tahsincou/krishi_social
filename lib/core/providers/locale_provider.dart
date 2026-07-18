import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_mvp_starter/core/locale/locale_notifier.dart';
import 'package:flutter_mvp_starter/core/services/locale_service.dart';

final localeServiceProvider = Provider((ref) => LocaleService());

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.read(localeServiceProvider));
});
