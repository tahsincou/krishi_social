import 'package:krishi_social/features/auth/domain/entities/account_activity.dart';
import 'package:krishi_social/features/auth/domain/entities/verification_status.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final AccountActivity activity;
  final VerificationStatus verificationStatus;
  final String token;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.activity,
    required this.verificationStatus,
    required this.token,
  });

  bool get isReviewed => verificationStatus == VerificationStatus.reviewed;
}
