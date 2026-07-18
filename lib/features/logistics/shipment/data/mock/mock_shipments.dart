import '../../domain/entities/shipment.dart';

const mockShipments = [
  Shipment(
    trackingId: 'TRK-1001',
    customer: 'John Doe',
    phone: '+1 555 123 456',
    address: '221B Baker Street, London',
    status: 'Delivered',
  ),
  Shipment(
    trackingId: 'TRK-1002',
    customer: 'Alice Smith',
    phone: '+1 555 987 654',
    address: '742 Evergreen Terrace',
    status: 'Pending',
  ),
  Shipment(
    trackingId: 'TRK-1003',
    customer: 'David Brown',
    phone: '+1 555 456 789',
    address: '1600 Pennsylvania Ave',
    status: 'Failed',
  ),
];
