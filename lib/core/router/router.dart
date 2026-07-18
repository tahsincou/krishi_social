import 'package:go_router/go_router.dart';
import 'package:flutter_mvp_starter/features/auth/presentaion/pages/login_page.dart';
import 'package:flutter_mvp_starter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/presentation/pages/create_shipment_page.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/presentation/pages/shipment_details_page.dart';
import 'package:flutter_mvp_starter/features/settings/settings_page.dart';
import 'package:flutter_mvp_starter/features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
      GoRoute(
        path: '/shipment-details',
        builder: (context, state) {
          final shipment = state.extra as Shipment;

          return ShipmentDetailsPage(shipment: shipment);
        },
      ),
      GoRoute(
        path: '/create-shipment',
        builder: (context, state) => const ShipmentFormPage(),
      ),
      GoRoute(
        path: '/edit-shipment',
        builder: (context, state) {
          final shipment = state.extra as Shipment;

          return ShipmentFormPage(shipment: shipment);
        },
      ),
    ],
  );
}
