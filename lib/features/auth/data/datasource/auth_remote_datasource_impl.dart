import 'package:krishi_social/core/network/api_client.dart';
import 'package:krishi_social/features/auth/data/model/user_model.dart';

import '../../../../core/network/api_endpoints.dart';
import '../dto/login_request.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> login(LoginRequest request) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    return UserModel.fromJson(response.data!);
  }
}
