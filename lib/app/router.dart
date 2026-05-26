import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/features/about_us/screens/about_us_screen.dart';
import 'package:rede_campo_online/features/articles/models/articles.dart';
import 'package:rede_campo_online/features/articles/screens/article_details_screen.dart';
import 'package:rede_campo_online/features/home/screens/home_screen.dart';

import '../features/projects/models/projects.dart';
import '../features/projects/screens/project_details_screen.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/publications/screens/publications_screen.dart';

abstract class AppRoutes {
  static const home = '/';
  static const aboutUs = '/sobre-nos';
  static const projects = '/projects';
  static const projectDetail = '/projects/:id';
  static const publications = '/publications';
  static const articleDetail = '/publications/articles/:id';
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
    GoRoute(
      path: AppRoutes.projects,
      builder: (context, state) => const ProjectsScreen(),
    ),
    GoRoute(
      path: AppRoutes.projectDetail,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! Projects) return const ProjectsScreen();
        return ProjectDetailsScreen(project: extra);
      },
    ),
    GoRoute(
      path: AppRoutes.publications,
      builder: (context, state) => const PublicationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.articleDetail,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! Articles) return const PublicationsScreen();
        return ArticleDetailsScreen(article: extra);
      },
    ),
  ],
);
