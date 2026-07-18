class CreateShipmentRequest {
  final String customer;
  final String phone;
  final String address;

  const CreateShipmentRequest({
    required this.customer,
    required this.phone,
    required this.address,
  });
}
