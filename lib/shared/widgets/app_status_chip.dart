import 'package:flutter/material.dart';
import 'package:flutter_mvp_starter/shared/theme/app_text_styles.dart';

import '../theme/app_colors.dart';

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final style = _getStyle(status);

    return Chip(
      avatar: Icon(style.icon, size: 18, color: style.foreground),
      label: Text(status, style: AppTextStyles.caption),
      backgroundColor: style.background,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  _StatusStyle _getStyle(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return _StatusStyle(
          background: AppColors.warning.withValues(alpha: 0.15),
          foreground: AppColors.warning,
          icon: Icons.schedule,
        );

      case 'completed':
      case 'delivered':
        return _StatusStyle(
          background: AppColors.success.withValues(alpha: 0.15),
          foreground: AppColors.success,
          icon: Icons.check_circle,
        );

      case 'failed':
      case 'cancelled':
        return _StatusStyle(
          background: AppColors.error.withValues(alpha: 0.15),
          foreground: AppColors.error,
          icon: Icons.cancel,
        );

      case 'in transit':
        return _StatusStyle(
          background: AppColors.info.withValues(alpha: 0.15),
          foreground: AppColors.info,
          icon: Icons.local_shipping,
        );

      default:
        return _StatusStyle(
          background: AppColors.neutralLight,
          foreground: AppColors.textSecondary,
          icon: Icons.info,
        );
    }
  }
}

class _StatusStyle {
  final Color background;
  final Color foreground;
  final IconData icon;

  const _StatusStyle({
    required this.background,
    required this.foreground,
    required this.icon,
  });
}
