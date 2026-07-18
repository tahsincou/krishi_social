import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mvp_starter/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:flutter_mvp_starter/core/locale/locale_extension.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Parcel Pathai"),
              accountEmail: Text("user@logistics.com"),
              currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
            ),

            // ListTile(
            //   leading: const Icon(Icons.dashboard),
            //   title: const Text("Dashboard"),
            //   onTap: () {
            //     context.go('/dashboard');
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(context.l10n.settings),
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),

            const Spacer(),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(context.l10n.logout),
              onTap: () async {
                await ref.read(authNotifierProvider.notifier).logout();

                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
