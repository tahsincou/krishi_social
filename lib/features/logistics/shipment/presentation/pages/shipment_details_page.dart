import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/presentation/notifiers/shipment_details/shipment_details_provider.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/presentation/providers/shipment_notifier.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/presentation/widgets/shipment_timeline_widget.dart';
import 'package:flutter_mvp_starter/shared/theme/app_spacing.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_card.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_loading.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_section.dart';
import 'package:flutter_mvp_starter/shared/widgets/confirmation_dialog.dart';
import 'package:flutter_mvp_starter/shared/widgets/info_tile.dart';

import '../../domain/entities/shipment.dart';

class ShipmentDetailsPage extends ConsumerStatefulWidget {
  final Shipment shipment;

  const ShipmentDetailsPage({super.key, required this.shipment});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShipmentDetailsPageState();
}

class _ShipmentDetailsPageState extends ConsumerState<ShipmentDetailsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(shipmentDetailsNotifierProvider.notifier)
          .load(widget.shipment.trackingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shipmentDetailsNotifierProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: AppLoading(message: 'Loading shipment details...')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipment Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => const ConfirmationDialog(
                  title: 'Delete Shipment',
                  message: 'Are you sure you want to delete this shipment?',
                ),
              );

              if (confirmed != true) return;
              final success = await ref
                  .read(shipmentNotifierProvider.notifier)
                  .deleteShipment(widget.shipment.trackingId);

              if (!context.mounted) return;

              if (success) {
                context.pop(true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.local_shipping, size: 36),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.shipment.trackingId,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),

                            const SizedBox(height: 8),

                            Chip(
                              avatar: const Icon(
                                Icons.local_shipping,
                                size: 18,
                              ),
                              label: Text(widget.shipment.status),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              widget.shipment.customer,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: AppCard(
                child: Column(
                  children: [
                    InfoTile(
                      icon: Icons.person,
                      title: 'Customer',
                      value: widget.shipment.customer,
                    ),
                    Divider(height: 1),
                    InfoTile(
                      icon: Icons.phone,
                      title: 'Phone',
                      value: widget.shipment.phone,
                    ),
                    Divider(height: 1),
                    InfoTile(
                      icon: Icons.location_on,
                      title: 'Address',
                      value: widget.shipment.address,
                    ),
                    Divider(height: 1),
                    InfoTile(
                      icon: Icons.local_shipping,
                      title: 'Status',
                      value: widget.shipment.status,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSection(
                      title: "Shipment Progress",
                      child: ShipmentTimelineWidget(
                        timeline: state.details?.timeline ?? const [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final updated = await context.push<bool>(
            '/edit-shipment',
            extra: widget.shipment,
          );

          if (updated == true && context.mounted) {
            context.pop(true);
          }
        },
        icon: const Icon(Icons.edit),
        label: const Text("Edit"),
      ),
    );
  }
}
