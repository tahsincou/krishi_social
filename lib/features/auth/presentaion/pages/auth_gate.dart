import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/features/auth/domain/entities/auth_status.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(
      authNotifierProvider.select((state) => state.status),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      switch (authStatus) {
        case AuthStatus.authenticated:
          context.go('/feed');
          break;

        case AuthStatus.unauthenticated:
          context.go('/login');
          break;

        case AuthStatus.initial:
        case AuthStatus.restoring:
          break;
      }
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
