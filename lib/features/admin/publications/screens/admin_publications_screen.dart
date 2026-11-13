import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_create_fab.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_entity_list_section.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_mobile_page_scaffold.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_table.dart';
import 'package:rede_campo_online/core/utils/admin_navigation.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:rede_campo_online/features/admin/publications/models/publication_type.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/listing/admin_publications_list_mobile.dart';
import 'package:rede_campo_online/features/admin/publications/stores/admin_publications_store.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_desktop_shell.dart';
import 'package:rede_campo_online/features/publications/models/publications.dart';

class AdminPublicationsScreen extends StatefulWidget {
  const AdminPublicationsScreen({super.key});

  @override
  State<AdminPublicationsScreen> createState() =>
      _AdminPublicationsScreenState();
}

class _AdminPublicationsScreenState extends State<AdminPublicationsScreen> {
  final _adminPublicationsStore = AdminPublicationsStore();

  static const _columns = [
    AdminTableColumn('Tipo', width: 170),
    AdminTableColumn('Título'),
    AdminTableColumn('Data', width: 110),
    AdminTableColumn('Áreas de pesquisa', width: 260),
  ];

  Future<void> _openForm([Publications? publication]) async {
    await openAdminForm(
      context,
      AppRoutes.adminCreatePublication,
      extra: publication,
    );
    _adminPublicationsStore.refreshData();
  }

  List<Widget> _cells(Publications publication) => [
        AdminTableChips(
          labels: [
            PublicationType.fromApi(publication.publication_type)?.label ?? '',
          ],
          color: CustomColors.copper_spice,
        ),
        AdminTableTitle(
          title: publication.title ?? '-',
          subtitle: publication.project?.name,
        ),
        AdminTableText(publication.publication_date?.formattedDate()),
        AdminTableChips(
          labels: (publication.research_areas ?? [])
              .map((a) => a.name ?? '')
              .toList(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AdminCreateFab.isVisible(context)
          ? AdminCreateFab(label: 'Nova Publicação', onPressed: _openForm)
          : null,
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: AdminMobilePageScaffold(
          title: 'Gerenciar Publicações',
          subtitle: 'Selecione uma publicação para editar.',
          onBack: () => closeAdminPage(context, AppRoutes.admin),
          child: AdminPublicationsListMobile(
            adminPublicationsStore: _adminPublicationsStore,
            onTapPublication: _openForm,
          ),
        ),
        child: AdminDesktopShell(
          child: AdminEntityListSectionDesktopVersion<Publications>(
            store: _adminPublicationsStore,
            title: 'Publicações',
            subtitle: 'Clique em uma linha para editar.',
            searchHint: 'Pesquisar publicações',
            errorMessage: 'Não foi possível carregar as publicações.',
            emptyMessage: 'Nenhuma publicação cadastrada.',
            createLabel: 'Nova publicação',
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
