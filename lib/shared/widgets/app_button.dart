import 'package:flutter/material.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_loading.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? Function()? validator;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading ? const AppLoading(message: 'Loading...') : Text(text),
      ),
    );
  }
}
