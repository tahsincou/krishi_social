import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
import 'package:krishi_social/shared/theme/app_radius.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_button.dart';
import 'package:krishi_social/shared/widgets/app_card.dart';
import 'package:krishi_social/shared/widgets/app_text_field.dart';
import 'package:krishi_social/shared/widgets/environment_badge.dart';
import 'package:krishi_social/shared/widgets/environment_bottom_sheet.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: 'buyer@demo.com');

  final _passwordController = TextEditingController(text: '123456');

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context),

                    const SizedBox(height: AppSpacing.xl),

                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            controller: _emailController,
                            label: context.l10n.email,
                            hint: context.l10n.enterEmail,
                            prefixIcon: const Icon(Icons.email_outlined),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: _validateEmail,
                          ),

                          const SizedBox(height: AppSpacing.md),

                          AppTextField(
                            controller: _passwordController,
                            label: context.l10n.password,
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              if (!authState.isLoading) {
                                _login();
                              }
                            },
                            validator: _validatePassword,
                          ),

                          if (authState.error != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            _buildErrorMessage(context, authState.error!),
                          ],

                          const SizedBox(height: AppSpacing.lg),

                          AppButton(
                            text: context.l10n.login,
                            isLoading: authState.isLoading,
                            onPressed: authState.isLoading ? null : _login,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    _buildRegistrationAction(context),

                    const SizedBox(height: AppSpacing.lg),

                    Center(child: EnvironmentBadge(onTap: _changeEnvironment)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Icon(
            Icons.agriculture_rounded,
            size: 56,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        Text(
          context.l10n.appName,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        Text(
          context.l10n.loginWelcomeMessage,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context, String error) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: colorScheme.onErrorContainer,
          ),

          const SizedBox(width: AppSpacing.sm),

          Expanded(
            child: Text(
              error,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationAction(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.noAccountYet,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        TextButton(
          onPressed: () {
            context.push('/register');
          },
          child: Text(context.l10n.createAccount),
        ),
      ],
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref
        .read(authNotifierProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted || !success) {
      return;
    }

    await ref.read(feedNotifierProvider.notifier).initialize();

    if (!mounted) {
      return;
    }

    context.go('/feed');
  }

  Future<void> _changeEnvironment() async {
    final changed = await showEnvironmentBottomSheet(context);

    if (!mounted) {
      return;
    }

    if (changed == true) {
      context.go('/splash');
    }
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return context.l10n.enterEmail;
    }

    final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    if (!isValid) {
      return context.l10n.enterValidEmail;
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.enterPassword;
    }

    return null;
  }
}
