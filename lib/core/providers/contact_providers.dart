import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/services/contact_service.dart';

final contactServiceProvider = Provider<ContactService>((ref) {
  return const ContactService();
});
