import 'package:flutter/material.dart';
import 'package:flutter_mvp_starter/shared/theme/app_colors.dart';
import 'package:flutter_mvp_starter/shared/theme/app_text_styles.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              Icon(icon, size: 25, color: iconColor ?? AppColors.primary),

            Text(value, style: AppTextStyles.title),

            Text(title, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
