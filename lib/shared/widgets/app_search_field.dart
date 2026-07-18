import 'package:flutter/material.dart';

import '../theme/app_radius.dart';

class AppSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const AppSearchField({
    super.key,
    required this.onChanged,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
