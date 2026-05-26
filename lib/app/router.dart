import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/features/about_us/screens/about_us_screen.dart';
import 'package:rede_campo_online/features/articles/models/articles.dart';
import 'package:rede_campo_online/features/articles/screens/article_details_screen.dart';
import 'package:rede_campo_online/features/book_chapters/models/book_chapters.dart';
import 'package:rede_campo_online/features/book_chapters/screens/book_chapter_details_screen.dart';
import 'package:rede_campo_online/features/books/models/books.dart';
import 'package:rede_campo_online/features/books/screens/book_details_screen.dart';
import 'package:rede_campo_online/features/home/screens/home_screen.dart';
import 'package:rede_campo_online/features/technical_reports/models/technical_reports.dart';
import 'package:rede_campo_online/features/technical_reports/screens/technical_report_details_screen.dart';

import '../features/news/models/news.dart';
import '../features/news/screens/news_details_screen.dart';
import '../features/news/screens/news_screen.dart';
import '../features/projects/models/projects.dart';
import '../features/projects/screens/project_details_screen.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/publications/screens/publications_screen.dart';

abstract class AppRoutes {
  static const home = '/';
  static const aboutUs = '/sobre-nos';
  static const projects = '/projects';
  static const projectDetail = '/projects/:id';
  static const news = '/news';
  static const newsDetail = '/news/:id';
  static const publications = '/publications';
  static const articleDetail = '/publications/articles/:id';
  static const technicalReportDetail = '/publications/technical-reports/:id';
  static const bookDetail = '/publications/books/:id';
  static const bookChapterDetail = '/publications/book-chapters/:id';
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
      path: AppRoutes.technicalReportDetail,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! TechnicalReports) return const PublicationsScreen();
        return TechnicalReportDetailsScreen(technicalReport: extra);
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
  ],
);
