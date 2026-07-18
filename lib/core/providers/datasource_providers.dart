import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/providers/database_helper_providers.dart';
import 'package:krishi_social/core/providers/providers.dart';
import 'package:krishi_social/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:krishi_social/features/auth/data/datasource/auth_remote_datasource_impl.dart';
import 'package:krishi_social/features/logistics/shipment/data/datasources/shipment_local_data_source.dart';
import 'package:krishi_social/features/logistics/shipment/data/datasources/shipment_local_data_source_impl.dart';
import 'package:krishi_social/features/logistics/shipment/data/datasources/shipment_memory_data_source.dart';
import 'package:krishi_social/features/logistics/shipment/data/datasources/shipment_remote_datasource.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(apiClientProvider));
});

final shipmentRemoteDataSourceProvider = Provider<ShipmentRemoteDataSource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);

  return ShipmentRemoteDataSource(apiClient);
});

final shipmentLocalDataSourceProvider = Provider<ShipmentLocalDataSource>((
  ref,
) {
  if (kIsWeb) {
    return ShipmentInMemoryDataSource();
  }

  return ShipmentLocalDataSourceImpl(ref.read(databaseHelperProvider));
});
