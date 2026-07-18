import 'package:flutter/material.dart';
import 'package:flutter_mvp_starter/core/config/app_config.dart';
import 'package:flutter_mvp_starter/core/config/environment.dart';
import 'package:flutter_mvp_starter/shared/theme/app_text_styles.dart';

import '../theme/app_spacing.dart';

Future<bool?> showEnvironmentBottomSheet(BuildContext context) async {
  Environment selected = AppConfig.environment;
  final availableEnvironments = [
    Environment.demo,
    Environment.development,
    Environment.staging,
    Environment.production,
  ];
  return await showModalBottomSheet<bool>(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Environment', style: AppTextStyles.heading),

                SizedBox(height: AppSpacing.lg),

                ...availableEnvironments.map(
                  (environment) => RadioListTile<Environment>(
                    value: environment,
                    groupValue: selected,
                    title: Text(environment.title),
                    subtitle: Text(environment.description),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selected = value);
                      }
                    },
                  ),
                ),

                SizedBox(height: AppSpacing.lg),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (selected != AppConfig.environment) {
                        await AppConfig.changeEnvironment(selected);

                        if (context.mounted) {
                          Navigator.pop(context, true);
                        }
                      } else {
                        Navigator.pop(context, false);
                      }
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
