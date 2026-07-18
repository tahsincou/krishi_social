import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mvp_starter/features/dashboard/presentation/providers/dashboard_notifier.dart';
import 'package:flutter_mvp_starter/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/presentation/providers/shipment_notifier.dart';
import 'package:flutter_mvp_starter/shared/theme/app_colors.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_drawer.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_empty.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_loading.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_search_field.dart';
import 'package:flutter_mvp_starter/shared/widgets/dashboard_card.dart';
import 'package:flutter_mvp_starter/shared/widgets/shipment_tile.dart';
import 'package:flutter_mvp_starter/shared/widgets/status_filter_chips.dart';

import '../../../../shared/theme/app_spacing.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(dashboardNotifierProvider.notifier).loadSummary();
      ref.read(shipmentNotifierProvider.notifier).loadShipments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardNotifierProvider);
    final shipmentState = ref.watch(shipmentNotifierProvider);
    final summary = ref.watch(dashboardSummaryProvider);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Parcel Pathai'),
        actions: [
          if (state.isFromCache) Icon(Icons.wifi_off, color: AppColors.error),
        ],
      ),
      body: state.isLoading
          ? const Center(child: AppLoading(message: 'Loading dashboard...'))
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(shipmentNotifierProvider.notifier)
                    .loadShipments();
              },
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      height: 150,
                      child: GridView.count(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 0.8,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          DashboardCard(
                            title: 'Deliveries',
                            value: summary.deliveries.toString(),
                            icon: Icons.local_shipping,
                            iconColor: Colors.blue.shade700,
                          ),
                          DashboardCard(
                            title: 'Pending',
                            value: summary.pending.toString(),
                            icon: Icons.schedule,
                            iconColor: Colors.orange.shade700,
                          ),
                          DashboardCard(
                            title: 'Completed',
                            value: summary.completed.toString(),
                            icon: Icons.check_circle,
                            iconColor: Colors.green.shade700,
                          ),
                          DashboardCard(
                            title: 'Failed',
                            value: summary.failed.toString(),
                            icon: Icons.cancel,
                            iconColor: Colors.red.shade700,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    StatusFilterChips(
                      selected: shipmentState.statusFilter,
                      onSelected: (status) {
                        ref
                            .read(shipmentNotifierProvider.notifier)
                            .filterShipments(status: status);
                      },
                    ),

                    const SizedBox(height: 16),

                    AppSearchField(
                      hintText: 'Search by tracking ID or customer',
                      onChanged: (value) {
                        ref
                            .read(shipmentNotifierProvider.notifier)
                            .filterShipments(searchQuery: value);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      'Recent Shipments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await ref
                              .read(shipmentNotifierProvider.notifier)
                              .loadShipments();
                        },
                        child: shipmentState.shipments.isEmpty
                            ? Center(
                                child: const AppEmpty(
                                  title: 'No Shipments',
                                  message: 'Create your first shipment.',
                                  icon: Icons.local_shipping_outlined,
                                ),
                              )
                            : ListView.builder(
                                itemCount: shipmentState.shipments.length,
                                itemBuilder: (context, index) {
                                  final shipment =
                                      shipmentState.shipments[index];
                                  return ShipmentTile(
                                    shipment: shipment,
                                    onTap: () async {
                                      final result = await context.push<bool>(
                                        '/shipment-details',
                                        extra: shipment,
                                      );

                                      if (result == true) {
                                        ref
                                            .read(
                                              shipmentNotifierProvider.notifier,
                                            )
                                            .loadShipments();
                                      }
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await context.push<bool>('/create-shipment');

          if (created == true && mounted) {
            ref.read(shipmentNotifierProvider.notifier).loadShipments();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
