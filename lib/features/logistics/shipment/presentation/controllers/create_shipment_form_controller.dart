import 'package:flutter/material.dart';

class CreateShipmentFormController {
  final parcelTypes = ['Document', 'Electronics', 'Clothing', 'Food', 'Others'];
  final formKey = GlobalKey<FormState>();

  final customerController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final weightController = TextEditingController();
  final deliveryChargeController = TextEditingController();

  String? parcelType;

  void dispose() {
    customerController.dispose();
    phoneController.dispose();
    addressController.dispose();
    weightController.dispose();
    deliveryChargeController.dispose();
  }
}
