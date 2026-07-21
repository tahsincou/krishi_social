import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/features/auth/domain/entities/auth_status.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthStatus>(
      authNotifierProvider.select((state) => state.status),
      (previous, current) {
        if (current == AuthStatus.authenticated) {
          context.go('/feed');
        } else if (current == AuthStatus.unauthenticated) {
          context.go('/login');
        }
      },
    );

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
