import 'package:flutter/material.dart';
import 'package:flutter_mvp_starter/shared/theme/app_spacing.dart';
import 'package:flutter_mvp_starter/shared/theme/app_text_styles.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value, style: AppTextStyles.body),
      ),
    );
  }
}
