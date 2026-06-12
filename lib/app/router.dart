import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/features/about_us/screens/about_us_screen.dart';
import 'package:rede_campo_online/features/admin/events/screens/admin_create_event_screen.dart';
import 'package:rede_campo_online/features/admin/events/screens/admin_events_screen.dart';
import 'package:rede_campo_online/features/admin/news/screens/admin_create_news_screen.dart';
import 'package:rede_campo_online/features/admin/news/screens/admin_news_screen.dart';
import 'package:rede_campo_online/features/admin/projects/screens/admin_create_project_screen.dart';
import 'package:rede_campo_online/features/admin/projects/screens/admin_projects_screen.dart';
import 'package:rede_campo_online/features/admin/publications/screens/admin_create_publication_screen.dart';
import 'package:rede_campo_online/features/admin/publications/screens/admin_publications_screen.dart';
import 'package:rede_campo_online/features/admin/screens/admin_screen.dart';
import 'package:rede_campo_online/features/login/screens/login_screen.dart';
import 'package:rede_campo_online/features/articles/models/articles.dart';
import 'package:rede_campo_online/features/articles/screens/article_details_screen.dart';
import 'package:rede_campo_online/features/book_chapters/models/book_chapters.dart';
import 'package:rede_campo_online/features/book_chapters/screens/book_chapter_details_screen.dart';
import 'package:rede_campo_online/features/books/models/books.dart';
import 'package:rede_campo_online/features/books/screens/book_details_screen.dart';
import 'package:rede_campo_online/features/home/screens/home_screen.dart';

import '../core/global/injection.dart';
import '../core/stores/user_manager_store.dart';
import '../features/events/models/events.dart';
import '../features/events/screens/event_details_screen.dart';
import '../features/events/screens/events_screen.dart';
import '../features/news/models/news.dart';
import '../features/news/screens/news_details_screen.dart';
import '../features/news/screens/news_screen.dart';
import '../features/projects/models/projects.dart';
import '../features/projects/screens/project_details_screen.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/publications/models/publications.dart';
import '../features/publications/screens/publications_screen.dart';
import '../features/thesis/models/thesis.dart';
import '../features/thesis/screens/thesis_details_screen.dart';

abstract class AppRoutes {
  static const home = '/';
  static const aboutUs = '/sobre-nos';
  static const projects = '/projects';
  static const projectDetail = '/projects/:id';
  static const news = '/news';
  static const newsDetail = '/news/:id';
  static const publications = '/publications';
  static const articleDetail = '/publications/articles/:id';
  static const thesisDetail = '/publications/thesis/:id';
  static const bookDetail = '/publications/books/:id';
  static const bookChapterDetail = '/publications/book-chapters/:id';
  static const events = '/events';
  static const eventDetail = '/events/:id';
  static const login = '/login';
  static const admin = '/admin';
  static const adminNews = '/admin/news';
  static const adminCreateNews = '/admin/news/create';
  static const adminProjects = '/admin/projects';
  static const adminCreateProject = '/admin/projects/create';
  static const adminEvents = '/admin/events';
  static const adminCreateEvent = '/admin/events/create';
  static const adminPublications = '/admin/publications';
  static const adminCreatePublication = '/admin/publications/create';
}

/// Notifies GoRouter whenever the auth state changes so the redirect
/// re-evaluates without requiring manual navigation.
class _AuthChangeNotifier extends ChangeNotifier {
  late final ReactionDisposer _disposer;

  _AuthChangeNotifier() {
    final userStore = getIt<UserManagerStore>();
    _disposer = autorun((_) {
      // Accessing isLoggedIn registers it as a dependency of this reaction.
      userStore.isLoggedIn;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }
}

final _authNotifier = _AuthChangeNotifier();

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  refreshListenable: _authNotifier,
  redirect: (context, state) {
    final isLoggedIn = getIt<UserManagerStore>().isLoggedIn;
    final path = state.uri.path;
    final isAdminPath = path.startsWith('/admin');

    if (isAdminPath && !isLoggedIn) return AppRoutes.login;
    if (path == AppRoutes.login && isLoggedIn) return AppRoutes.admin;

    return null;
  },
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
      path: AppRoutes.news,
      builder: (context, state) => const NewsScreen(),
    ),
    GoRoute(
      path: AppRoutes.newsDetail,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! News) return const NewsScreen();
        return NewsDetailsScreen(news: extra);
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
    GoRoute(
      path: AppRoutes.thesisDetail,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! Thesis) return const PublicationsScreen();
        return ThesisDetailsScreen(thesis: extra);
      },
    ),
    GoRoute(
      path: AppRoutes.bookDetail,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! Books) return const PublicationsScreen();
        return BookDetailsScreen(book: extra);
      },
    ),
    GoRoute(
      path: AppRoutes.bookChapterDetail,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! BookChapters) return const PublicationsScreen();
        return BookChapterDetailsScreen(bookChapter: extra);
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.events,
      builder: (context, state) => const EventsScreen(),
    ),
    GoRoute(
      path: AppRoutes.eventDetail,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! Events) return const EventsScreen();
        return EventDetailsScreen(event: extra);
      },
    ),
    // Admin routes
    GoRoute(
      path: AppRoutes.admin,
      builder: (context, state) => const AdminScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminNews,
      builder: (context, state) => const AdminNewsScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminCreateNews,
      builder: (context, state) {
        final extra = state.extra;
        return AdminCreateNewsScreen(news: extra is News ? extra : null);
      },
    ),
    GoRoute(
      path: AppRoutes.adminProjects,
      builder: (context, state) => const AdminProjectsScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminCreateProject,
      builder: (context, state) {
        final extra = state.extra;
        return AdminCreateProjectScreen(
            project: extra is Projects ? extra : null);
      },
    ),
    GoRoute(
      path: AppRoutes.adminEvents,
      builder: (context, state) => const AdminEventsScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminCreateEvent,
      builder: (context, state) {
        final extra = state.extra;
        return AdminCreateEventScreen(event: extra is Events ? extra : null);
      },
    ),
    GoRoute(
      path: AppRoutes.adminPublications,
      builder: (context, state) => const AdminPublicationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminCreatePublication,
      builder: (context, state) {
        final extra = state.extra;
        return AdminCreatePublicationScreen(
            publication: extra is Publications ? extra : null);
      },
    ),
  ],
);
