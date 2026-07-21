import 'package:go_router/go_router.dart';
import 'package:krishi_social/features/auth/presentaion/pages/auth_gate.dart';
import 'package:krishi_social/features/auth/presentaion/pages/login_page.dart';
import 'package:krishi_social/features/auth/presentaion/pages/register_page.dart';
import 'package:krishi_social/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/presentation/pages/create_post_page.dart';
import 'package:krishi_social/features/feed/presentation/pages/feed_page.dart';
import 'package:krishi_social/features/feed/presentation/pages/my_posts_page.dart';
import 'package:krishi_social/features/settings/settings_page.dart';
import 'package:krishi_social/features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardPage()),
      GoRoute(path: '/feed', builder: (_, __) => const FeedPage()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
      GoRoute(
        path: '/create-post',
        builder: (context, state) {
          final type = state.extra as PostType? ?? PostType.sell;
          return CreatePostPage(initialType: type);
        },
      ),
      GoRoute(
        path: '/edit-post',
        builder: (context, state) {
          final post = state.extra as AgriculturePost;

          return CreatePostPage(initialType: post.type, existingPost: post);
        },
      ),
      GoRoute(path: '/my-posts', builder: (_, __) => const MyPostsPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/', builder: (context, state) => const AuthGate()),
    ],
  );
}
