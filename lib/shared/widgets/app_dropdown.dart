import 'package:flutter/material.dart';

import '../theme/app_radius.dart';

class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String label;
  final ValueChanged<T?>? onChanged;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.onChanged,
    required String? Function(dynamic value) validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
