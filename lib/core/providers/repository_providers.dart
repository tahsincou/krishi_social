import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvp_starter/core/providers/providers.dart';
import 'package:flutter_mvp_starter/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_mvp_starter/features/auth/data/repository/auth_repository_impl.dart';
import 'package:flutter_mvp_starter/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:flutter_mvp_starter/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/data/repository/shipment_repository_impl.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/repository/shipment_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authRemoteDataSourceProvider),
    ref.read(secureStorageServiceProvider),
  );
});

final shipmentRepositoryProvider = Provider<ShipmentRepository>((ref) {
  return ShipmentRepositoryImpl(
    remote: ref.read(shipmentRemoteDataSourceProvider),
    local: ref.read(shipmentLocalDataSourceProvider),
  );
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});
