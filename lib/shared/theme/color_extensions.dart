import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color get soft => withValues(alpha: 0.15);
}
