import 'package:flutter/material.dart';
import 'package:krishi_social/shared/theme/app_text_styles.dart';
import '../../core/config/app_config.dart';

class EnvironmentBadge extends StatelessWidget {
  final VoidCallback onTap;

  const EnvironmentBadge({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        AppConfig.isDemo ? '🟠 Demo Mode' : '🟢 Live Mode',
        style: AppTextStyles.body,
      ),
    );
  }
}
