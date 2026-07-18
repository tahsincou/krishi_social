import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/database/database_helper.dart';
import 'package:krishi_social/core/providers/providers.dart';
import 'package:krishi_social/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:krishi_social/features/auth/data/datasource/auth_remote_datasource_impl.dart';
import 'package:krishi_social/features/feed/data/datasources/feed_local_datasource.dart';
import 'package:krishi_social/features/feed/data/datasources/feed_local_datasource_impl.dart';
import 'package:krishi_social/features/feed/data/datasources/feed_memory_datasource_impl.dart';
import 'package:krishi_social/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:krishi_social/features/feed/data/datasources/feed_remote_data_source_impl.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(apiClientProvider));
});

final feedRemoteDataSourceProvider = Provider<FeedRemoteDataSource>((ref) {
  return FeedRemoteDataSourceImpl(ref.read(apiClientProvider));
});

final feedLocalDataSourceProvider = Provider<FeedLocalDataSource>((ref) {
  if (kIsWeb) {
    return FeedMemoryDataSourceImpl();
  }

  return FeedLocalDataSourceImpl(DatabaseHelper.instance);
});
