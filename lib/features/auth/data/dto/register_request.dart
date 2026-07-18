import 'package:krishi_social/features/auth/domain/entities/account_activity.dart';

class RegisterRequest {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String location;
  final AccountActivity activity;

  const RegisterRequest({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.location,
    required this.activity,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'location': location,
      'activity': activity.name,
    };
  }
}
