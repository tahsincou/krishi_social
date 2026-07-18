import 'package:flutter_mvp_starter/features/auth/data/repository/auth_repository.dart';

import '../entities/user.dart';

class CheckLoginUseCase {
  final AuthRepository repository;

  const CheckLoginUseCase(this.repository);

  Future<User?> call() {
    return repository.currentUser();
  }
}
