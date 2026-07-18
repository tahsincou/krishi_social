class Validators {
  Validators._();

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone is required';
    }

    final phoneRegex = RegExp(r'^[0-9+\-\s()]{8,20}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  static String? number(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value.trim()) == null) {
      return 'Enter a valid $fieldName';
    }

    return null;
  }

  static String? dropdown(dynamic value, String fieldName) {
    if (value == null) {
      return 'Please select $fieldName';
    }

    return null;
  }
}
