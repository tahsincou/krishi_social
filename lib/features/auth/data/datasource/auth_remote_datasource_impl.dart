import 'package:flutter/material.dart';
import 'package:krishi_social/core/network/api_client.dart';
import 'package:krishi_social/core/services/environment_service.dart';
import 'package:krishi_social/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:krishi_social/features/auth/data/dto/login_request.dart';
import 'package:krishi_social/features/auth/data/dto/register_request.dart';
import 'package:krishi_social/features/auth/data/model/user_model.dart';
import 'package:krishi_social/features/auth/domain/entities/account_activity.dart';
import 'package:krishi_social/features/auth/domain/entities/verification_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  SupabaseClient get _supabaseClient => Supabase.instance.client;

  @override
  Future<UserModel> login(LoginRequest request) async {
    if (await EnvironmentService.isDemo()) {
      return _loginDemo(request);
    }

    return _loginSupabase(request);
  }

  Future<UserModel> _loginDemo(LoginRequest request) async {
    final response = await apiClient.post(
      '/auth/login',
      data: request.toJson(),
    );

    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> _loginSupabase(LoginRequest request) async {
    try {
      debugPrint('Starting Supabase login: ${request.email}');

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: request.email,
        password: request.password,
      );

      debugPrint('Supabase login successful: ${response.user?.id}');

      final authUser = response.user;
      final session = response.session;

      if (authUser == null || session == null) {
        throw const AuthException('Unable to login.');
      }

      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      return UserModel(
        id: authUser.id,
        name: profile?['name']?.toString() ?? '',
        email: authUser.email ?? request.email,
        phone: profile?['phone']?.toString() ?? '',
        location: profile?['location']?.toString() ?? '',
        activity: AccountActivity.values.byName(
          profile?['activity']?.toString() ?? AccountActivity.both.name,
        ),
        verificationStatus: VerificationStatus.values.byName(
          profile?['verification_status']?.toString() ??
              VerificationStatus.pending.name,
        ),
        token: session.accessToken,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint(
        'Supabase AuthException: '
        'message=${error.message}, '
        'status=${error.statusCode}, '
        'code=${error.code}',
      );
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('Unexpected Supabase login error: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    if (await EnvironmentService.isDemo()) {
      return _registerDemo(request);
    }

    return _registerSupabase(request);
  }

  Future<UserModel> _registerDemo(RegisterRequest request) async {
    final response = await apiClient.post(
      '/auth/register',
      data: request.toJson(),
    );

    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> _registerSupabase(RegisterRequest request) async {
    try {
      debugPrint('Supabase registration started');
      debugPrint('Email: ${request.email}');
      debugPrint('Project URL: ${_supabaseClient.rest.url}');

      final response = await _supabaseClient.auth.signUp(
        email: request.email,
        password: request.password,
        data: {
          'name': request.name,
          'phone': request.phone,
          'location': request.location,
          'activity': request.activity.name,
        },
      );

      debugPrint('Supabase signup response received');
      debugPrint('User ID: ${response.user?.id}');
      debugPrint('Session exists: ${response.session != null}');

      final authUser = response.user;

      if (authUser == null) {
        throw const AuthException(
          'Supabase did not return a user after registration.',
        );
      }

      final session = response.session;

      if (session == null) {
        throw const AuthException(
          'Account created. Please confirm your email before logging in.',
        );
      }

      debugPrint('Creating profile row for user: ${authUser.id}');

      await _supabaseClient.from('profiles').insert({
        'id': authUser.id,
        'name': request.name,
        'phone': request.phone,
        'location': request.location,
        'activity': request.activity.name,
        'verification_status': VerificationStatus.pending.name,
      });

      debugPrint('Profile row created successfully');

      return UserModel(
        id: authUser.id,
        name: request.name,
        email: authUser.email ?? request.email,
        phone: request.phone,
        location: request.location,
        activity: request.activity,
        verificationStatus: VerificationStatus.pending,
        token: session.accessToken,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint('Supabase registration AuthException');
      debugPrint('Message: ${error.message}');
      debugPrint('Status code: ${error.statusCode}');
      debugPrint('Code: ${error.code}');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    } on PostgrestException catch (error, stackTrace) {
      debugPrint('Supabase profile PostgrestException');
      debugPrint('Message: ${error.message}');
      debugPrint('Code: ${error.code}');
      debugPrint('Details: ${error.details}');
      debugPrint('Hint: ${error.hint}');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    } catch (error, stackTrace) {
      debugPrint('Unexpected Supabase registration error');
      debugPrint('Type: ${error.runtimeType}');
      debugPrint('Error: $error');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }
}
