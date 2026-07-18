import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mvp_starter/core/utils/validators.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/params/create_shipment.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/presentation/controllers/create_shipment_form_controller.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/presentation/providers/shipment_notifier.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_button.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_dropdown.dart';
import 'package:flutter_mvp_starter/shared/widgets/app_text_field.dart';

import '../../../../../shared/theme/app_spacing.dart';

class ShipmentFormPage extends ConsumerStatefulWidget {
  final Shipment? shipment;

  const ShipmentFormPage({super.key, this.shipment});

  @override
  ConsumerState<ShipmentFormPage> createState() => _CreateShipmentPageState();
}

class _CreateShipmentPageState extends ConsumerState<ShipmentFormPage> {
  late final CreateShipmentFormController form;

  @override
  void initState() {
    super.initState();

    form = CreateShipmentFormController();

    if (widget.shipment != null) {
      form.customerController.text = widget.shipment!.customer;
      form.phoneController.text = widget.shipment!.phone;
      form.addressController.text = widget.shipment!.address;
    }
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipmentState = ref.watch(shipmentNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.shipment == null ? 'Create Shipment' : 'Edit Shipment',
        ),
      ),
      body: Form(
        key: form.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Fields here
              AppTextField(
                controller: form.customerController,
                label: 'Customer Name',
                prefixIcon: const Icon(Icons.person),
                validator: (value) =>
                    Validators.required(value, 'Customer Name'),
              ),

              const SizedBox(height: 16),

              AppTextField(
                controller: form.phoneController,
                label: 'Phone',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone),
                validator: Validators.phone,
              ),

              const SizedBox(height: 16),

              AppTextField(
                controller: form.addressController,
                label: 'Address',
                maxLines: 3,
                prefixIcon: const Icon(Icons.location_on),
                validator: (value) => Validators.required(value, 'Address'),
              ),

              const SizedBox(height: 16),

              AppDropdown<String>(
                value: form.parcelType,
                label: 'Parcel Type',
                items: form.parcelTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    form.parcelType = value;
                  });
                },
                validator: (value) => Validators.dropdown(value, 'Parcel Type'),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: form.weightController,
                label: 'Weight (kg)',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.scale),
                validator: (value) => Validators.number(value, 'Weight'),
              ),
              const SizedBox(height: 16),

              AppTextField(
                controller: form.deliveryChargeController,
                label: 'Delivery Charge',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.payments),
                validator: (value) =>
                    Validators.number(value, 'Delivery Charge'),
              ),
              const SizedBox(height: AppSpacing.lg),

              AppButton(
                text: widget.shipment == null
                    ? 'Create Shipment'
                    : 'Update Shipment',
                isLoading: shipmentState.isSubmitting,
                onPressed: shipmentState.isSubmitting
                    ? null
                    : () async {
                        if (!form.formKey.currentState!.validate()) {
                          return;
                        }

                        final notifier = ref.read(
                          shipmentNotifierProvider.notifier,
                        );

                        bool success;

                        if (widget.shipment == null) {
                          final request = CreateShipmentRequest(
                            customer: form.customerController.text.trim(),
                            phone: form.phoneController.text.trim(),
                            address: form.addressController.text.trim(),
                          );

                          success = await notifier.createShipment(request);
                        } else {
                          final shipment = Shipment(
                            trackingId: widget.shipment!.trackingId,
                            customer: form.customerController.text.trim(),
                            phone: form.phoneController.text.trim(),
                            address: form.addressController.text.trim(),
                            status: widget.shipment!.status,
                          );

                          success = await notifier.updateShipment(shipment);
                        }

                        if (!mounted) return;

                        if (success) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.shipment == null
                                    ? 'Shipment created successfully'
                                    : 'Shipment updated successfully',
                              ),
                            ),
                          );

                          // ignore: use_build_context_synchronously
                          context.pop(true);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
