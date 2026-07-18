import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/providers/providers.dart';
import 'package:krishi_social/features/auth/data/repository/auth_repository.dart';
import 'package:krishi_social/features/auth/data/repository/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider),
    ref.read(secureStorageServiceProvider),
  );
});
