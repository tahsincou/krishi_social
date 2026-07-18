import 'package:flutter/material.dart';
import 'package:flutter_mvp_starter/shared/theme/app_text_styles.dart';

import '../theme/app_spacing.dart';

class AppSection extends StatelessWidget {
  const AppSection({super.key, required this.title, required this.child});

  final String title;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}
