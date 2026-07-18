import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_mvp_starter/core/providers/repository_providers.dart';
import 'package:flutter_mvp_starter/features/dashboard/domain/utils/dashboard_summary_calculator.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/repository/shipment_repository.dart';

import 'dashboard_state.dart';

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      return DashboardNotifier(ref.read(shipmentRepositoryProvider));
    });

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier(this._shipmentRepository) : super(const DashboardState());

  final ShipmentRepository _shipmentRepository;

  Future<void> loadSummary() async {
    state = state.copyWith(isLoading: true);

    final result = await _shipmentRepository.getRecentShipments();

    final summary = DashboardSummaryCalculator.calculate(result.data);

    state = state.copyWith(
      isLoading: false,
      summary: summary,
      isFromCache: result.isFromCache,
    );
  }
}
