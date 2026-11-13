import 'package:flutter/material.dart';
import 'package:rede_campo_online/app/router.dart';

/// Seção do painel: nome, ícone e rota para sidebar e atalhos.
class AdminSection {
  final String label;
  final String description;
  final IconData icon;
  final String listRoute;
  final String createRoute;

  /// Concordância de gênero dos atalhos ("Nova"/"Novo", "Ver todas"/"Ver todos").
  final bool feminine;

  const AdminSection({
    required this.label,
    required this.description,
    required this.icon,
    required this.listRoute,
    required this.createRoute,
    required this.feminine,
  });

  String get createLabel => feminine ? 'Nova' : 'Novo';
  String get seeAllLabel => feminine ? 'Ver todas' : 'Ver todos';

  bool isActive(String currentPath) => currentPath.startsWith(listRoute);
}

const List<AdminSection> adminSections = [
  AdminSection(
    label: 'Notícias',
    description: 'Acontecimentos, parcerias e conquistas do grupo.',
    icon: Icons.article_outlined,
    listRoute: AppRoutes.adminNews,
    createRoute: AppRoutes.adminCreateNews,
    feminine: true,
  ),
  AdminSection(
    label: 'Projetos',
    description: 'Pesquisa e extensão, com equipe, áreas e galeria.',
    icon: Icons.science_outlined,
    listRoute: AppRoutes.adminProjects,
    createRoute: AppRoutes.adminCreateProject,
    feminine: false,
  ),
  AdminSection(
    label: 'Eventos',
    description: 'Data, local e link de inscrição das atividades.',
    icon: Icons.event_outlined,
    listRoute: AppRoutes.adminEvents,
    createRoute: AppRoutes.adminCreateEvent,
    feminine: false,
  ),
  AdminSection(
    label: 'Publicações',
    description: 'Artigos, livros, capítulos e trabalhos acadêmicos.',
    icon: Icons.menu_book_outlined,
    listRoute: AppRoutes.adminPublications,
    createRoute: AppRoutes.adminCreatePublication,
    feminine: true,
  ),
  AdminSection(
    label: 'Membros',
    description: 'Pessoas do grupo, com função e organização.',
    icon: Icons.groups_outlined,
    listRoute: AppRoutes.adminMembers,
    createRoute: AppRoutes.adminCreateMember,
    feminine: false,
  ),
];
