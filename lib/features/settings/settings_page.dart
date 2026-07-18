import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvp_starter/core/locale/locale_extension.dart';
import 'package:flutter_mvp_starter/core/providers/theme_provider.dart';
import 'package:flutter_mvp_starter/shared/theme/app_radius.dart';
import 'package:flutter_mvp_starter/shared/theme/app_spacing.dart';

import '../../core/providers/locale_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  // ignore: use_super_parameters
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppRadius.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  title: Text(context.l10n.theme),
                  trailing: DropdownButton<ThemeMode>(
                    value: themeMode,
                    underline: const SizedBox.shrink(),
                    onChanged: (mode) {
                      if (mode != null) {
                        ref.read(themeModeProvider.notifier).change(mode);
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(context.l10n.system),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text(context.l10n.light),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text(context.l10n.dark),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Card(
                child: ListTile(
                  title: Text(context.l10n.language),
                  trailing: DropdownButton<String>(
                    value: locale.languageCode,
                    underline: const SizedBox.shrink(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(localeProvider.notifier).change(value);
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Card(
              //   child: ListTile(
              //     title: const Text('Refresh interval'),
              //     subtitle: Text(_refreshRate),
              //     trailing: DropdownButton<String>(
              //       value: _refreshRate,
              //       underline: const SizedBox.shrink(),
              //       onChanged: (value) {
              //         if (value != null) {
              //           setState(() {
              //             _refreshRate = value;
              //           });
              //         }
              //       },
              //       items: _refreshRates
              //           .map(
              //             (rate) =>
              //                 DropdownMenuItem(value: rate, child: Text(rate)),
              //           )
              //           .toList(),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
