import 'package:flutter/material.dart';
import 'package:flutter_mvp_starter/shared/theme/app_text_styles.dart';
import '../../core/config/app_config.dart';

class EnvironmentBadge extends StatelessWidget {
  final VoidCallback onLongPress;

  const EnvironmentBadge({super.key, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Text(
        AppConfig.isDemo ? '🟠 Demo Mode' : '🟢 Live Mode',
        style: AppTextStyles.body,
      ),
    );
  }
}
