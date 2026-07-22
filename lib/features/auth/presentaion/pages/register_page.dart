import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/auth/data/dto/register_request.dart';
import 'package:krishi_social/features/auth/domain/entities/account_activity.dart';
import 'package:krishi_social/features/auth/domain/extensions/account_activity_extension.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_button.dart';
import 'package:krishi_social/shared/widgets/app_dropdown.dart';
import 'package:krishi_social/shared/widgets/app_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _locationController = TextEditingController();

  AccountActivity _activity = AccountActivity.sell;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.createAccount)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(
                context.l10n.registerAccountTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.registerAccountMessage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                controller: _nameController,
                label: context.l10n.fullName,
                prefixIcon: const Icon(Icons.person_outline),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.enterYourName;
                  }

                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _phoneController,
                label: context.l10n.phoneNumber,
                hint: context.l10n.phoneNumberHint,
                prefixIcon: const Icon(Icons.phone_outlined),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: _validatePhone,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _emailController,
                label: context.l10n.email,
                prefixIcon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _passwordController,
                label: context.l10n.password,
                prefixIcon: const Icon(Icons.lock_outline),
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
                textInputAction: TextInputAction.next,
                validator: _validatePassword,
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _confirmPasswordController,
                label: context.l10n.confirmPassword,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.next,
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: AppSpacing.md),

              AppDropdown<AccountActivity>(
                value: _activity,
                label: context.l10n.mainActivity,
                prefixIcon: const Icon(Icons.swap_horiz_outlined),
                items: AccountActivity.values.map((activity) {
                  return DropdownMenuItem(
                    value: activity,
                    child: Text(activity.displayName(context)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _activity = value;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppTextField(
                controller: _locationController,
                label: context.l10n.location,
                hint: context.l10n.locationExample,
                prefixIcon: const Icon(Icons.location_on_outlined),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.enterYourLocation;
                  }

                  return null;
                },
                onFieldSubmitted: (_) => _register(),
              ),
              const SizedBox(height: AppSpacing.sm),

              Text(
                context.l10n.accountReviewMessage,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),

              if (authState.error != null) ...[
                Text(
                  authState.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              AppButton(
                text: context.l10n.createAccount,
                isLoading: authState.isLoading,
                onPressed: authState.isLoading ? null : _register,
              ),
              const SizedBox(height: AppSpacing.sm),

              TextButton(
                onPressed: authState.isLoading ? null : () => context.pop(),
                child: Text(context.l10n.alreadyHaveAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = RegisterRequest(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      location: _locationController.text.trim(),
      activity: _activity,
    );

    final success = await ref
        .read(authNotifierProvider.notifier)
        .register(request);

    if (!mounted || !success) {
      return;
    }

    await ref.read(feedNotifierProvider.notifier).initialize();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.registrationSuccessful)),
    );

    context.go('/feed');
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return context.l10n.enterPhoneNumber;
    }

    final normalizedPhone = phone.replaceAll(RegExp(r'[\s-]'), '');

    if (!RegExp(r'^01[3-9]\d{8}$').hasMatch(normalizedPhone)) {
      return context.l10n.enterValidPhoneNumber;
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return context.l10n.enterEmail;
    }

    final validEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    if (!validEmail) {
      return context.l10n.enterValidEmail;
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.enterPassword;
    }

    if (value.length < 6) {
      return context.l10n.passwordMinimumLength;
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.confirmYourPassword;
    }

    if (value != _passwordController.text) {
      return context.l10n.passwordsDoNotMatch;
    }

    return null;
  }
}
