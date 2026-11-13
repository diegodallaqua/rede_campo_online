import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/news/news_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_create_fab.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_entity_list_section.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_mobile_page_scaffold.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_table.dart';
import 'package:rede_campo_online/core/utils/admin_navigation.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:rede_campo_online/features/admin/news/stores/admin_news_store.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_desktop_shell.dart';
import 'package:rede_campo_online/features/news/models/news.dart';

class AdminNewsScreen extends StatefulWidget {
  const AdminNewsScreen({super.key});

  @override
  State<AdminNewsScreen> createState() => _AdminNewsScreenState();
}

class _AdminNewsScreenState extends State<AdminNewsScreen> {
  final _adminNewsStore = AdminNewsStore();

  static const _errorMessage = 'Não foi possível carregar as notícias.';
  static const _emptyMessage = 'Nenhuma notícia cadastrada.';
  static const _searchHint = 'Pesquisar notícias';

  static const _columns = [
    AdminTableColumn('', width: 56),
    AdminTableColumn('Título'),
    AdminTableColumn('Data', width: 110),
    AdminTableColumn('Áreas de pesquisa', width: 280),
  ];

  Future<void> _openForm([News? news]) async {
    await openAdminForm(context, AppRoutes.adminCreateNews, extra: news);
    _adminNewsStore.refreshData();
  }

  List<Widget> _cells(News news) => [
        AdminTableThumb(imageUrl: _adminNewsStore.mediaMap[news.id]?.media),
        AdminTableTitle(title: news.title ?? '-', subtitle: news.description),
        AdminTableText(news.publication_date?.formattedDate()),
        AdminTableChips(
          labels: (news.research_areas ?? []).map((a) => a.name ?? '').toList(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AdminCreateFab.isVisible(context)
          ? AdminCreateFab(label: 'Nova Notícia', onPressed: _openForm)
          : null,
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: AdminMobilePageScaffold(
          title: 'Gerenciar Notícias',
          subtitle: 'Selecione uma notícia para editar.',
          onBack: () => closeAdminPage(context, AppRoutes.admin),
          child: AdminEntityListSectionMobileVersion<News>(
            store: _adminNewsStore,
            errorMessage: _errorMessage,
            emptyMessage: _emptyMessage,
            searchHint: _searchHint,
            itemBuilder: (context, news) => NewsTileMobileVersion(
              news: news,
              newsMedia: _adminNewsStore.mediaMap[news.id],
              onTap: () => _openForm(news),
              isAdmin: true,
            ),
          ),
        ),
        child: AdminDesktopShell(
          child: AdminEntityListSectionDesktopVersion<News>(
            store: _adminNewsStore,
            title: 'Notícias',
            subtitle: 'Clique em uma linha para editar.',
            searchHint: _searchHint,
            errorMessage: _errorMessage,
            emptyMessage: _emptyMessage,
            createLabel: 'Nova notícia',
            onCreate: _openForm,
            columns: _columns,
            cellsBuilder: _cells,
            onEdit: _openForm,
          ),
        ),
      ),
    );
  }
}
