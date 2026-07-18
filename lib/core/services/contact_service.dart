import 'package:url_launcher/url_launcher.dart';

class ContactService {
  const ContactService();

  Future<void> call(String phoneNumber) async {
    final sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    if (sanitizedNumber.isEmpty) {
      throw const ContactException('Phone number is unavailable.');
    }

    final uri = Uri(scheme: 'tel', path: sanitizedNumber);

    final launched = await launchUrl(uri);

    if (!launched) {
      throw const ContactException('Unable to open the phone dialer.');
    }
  }
}

class ContactException implements Exception {
  final String message;

  const ContactException(this.message);

  @override
  String toString() => message;
}
