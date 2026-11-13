import 'package:rede_campo_online/app/router.dart';

/// Abas do site público, compartilhadas pela barra superior, pelo menu do
/// celular e pelo rodapé.
class NavItem {
  final String label;
  final String route;

  const NavItem({required this.label, required this.route});

  bool isActive(String currentPath) => route == currentPath;
}

const List<NavItem> navItems = [
  NavItem(label: 'Início', route: AppRoutes.home),
  NavItem(label: 'A Rede Campo', route: AppRoutes.aboutUs),
  NavItem(label: 'Projetos', route: AppRoutes.projects),
  NavItem(label: 'Publicações', route: AppRoutes.publications),
  NavItem(label: 'Eventos', route: AppRoutes.events),
  NavItem(label: 'Notícias', route: AppRoutes.news),
];
