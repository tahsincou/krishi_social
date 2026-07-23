import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/auth/domain/extensions/account_activity_extension.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:krishi_social/shared/theme/app_colors.dart';
import 'package:krishi_social/shared/theme/app_radius.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            if (user != null)
              _UserHeader(
                name: user.name,
                phone: user.phone,
                location: user.location,
                activity: user.activity.displayName(context),
              ),
            const Divider(),

            _DrawerItem(
              icon: Icons.home_outlined,
              label: context.l10n.home,
              onTap: () {
                Navigator.pop(context);
                context.go('/feed');
              },
            ),

            _DrawerItem(
              icon: Icons.article_outlined,
              label: context.l10n.myPosts,
              onTap: () {
                Navigator.pop(context);
                context.push('/my-posts');
              },
            ),

            _DrawerItem(
              icon: Icons.settings_outlined,
              label: context.l10n.settings,
              onTap: () {
                Navigator.pop(context);
                context.push('/settings');
              },
            ),

            const Spacer(),
            const Divider(),

            _DrawerItem(
              icon: Icons.logout_rounded,
              label: context.l10n.logout,
              foregroundColor: Theme.of(context).colorScheme.error,
              onTap: () async {
                Navigator.pop(context);

                await ref.read(authNotifierProvider.notifier).logout();

                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),

            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  const _UserHeader({
    required this.name,
    required this.phone,
    required this.location,
    required this.activity,
  });

  final String name;
  final String phone;
  final String location;
  final String activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: AppColors.primarySoft,
            child: Text(
              _initial(name),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 4),

          Text(
            phone,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          if (location.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.sm),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              activity,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.accentDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initial(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return '?';
    }

    return text.characters.first.toUpperCase();
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final color = foregroundColor ?? Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        onTap: onTap,
      ),
    );
  }
}
