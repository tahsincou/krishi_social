import 'package:krishi_social/features/auth/domain/entities/account_activity.dart';
import 'package:krishi_social/features/auth/domain/entities/user.dart';
import 'package:krishi_social/features/auth/domain/entities/verification_status.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.location,
    required super.activity,
    required super.verificationStatus,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      activity: AccountActivity.values.byName(
        json['activity']?.toString() ?? AccountActivity.both.name,
      ),
      verificationStatus: VerificationStatus.values.byName(
        json['verificationStatus']?.toString() ??
            VerificationStatus.pending.name,
      ),
      token: json['token']?.toString() ?? '',
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      location: user.location,
      activity: user.activity,
      verificationStatus: user.verificationStatus,
      token: user.token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'activity': activity.name,
      'verificationStatus': verificationStatus.name,
      'token': token,
    };
  }
}
