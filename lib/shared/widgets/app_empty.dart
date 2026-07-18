import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppEmpty extends StatelessWidget {
  const AppEmpty({
    super.key,
    this.title = 'No Data Found',
    this.message = 'There is nothing to display.',
    this.icon = Icons.inbox_outlined,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: AppColors.disabled),

            const SizedBox(height: AppSpacing.md),

            Text(title, style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: AppSpacing.sm),

            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
