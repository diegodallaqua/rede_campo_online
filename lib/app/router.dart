import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/features/about_us/screens/about_us_screen.dart';
import 'package:rede_campo_online/features/home/screens/home_screen.dart';

abstract class AppRoutes {
  static const home = '/';
  static const aboutUs = '/sobre-nos';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.aboutUs,
      builder: (context, state) => const AboutUsScreen(),
    ),
  ],
);
