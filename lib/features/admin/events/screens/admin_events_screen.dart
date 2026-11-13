import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/events/event_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_create_fab.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_entity_list_section.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_mobile_page_scaffold.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_table.dart';
import 'package:rede_campo_online/core/utils/admin_navigation.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:rede_campo_online/features/admin/events/stores/admin_events_store.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_desktop_shell.dart';
import 'package:rede_campo_online/features/events/models/events.dart';

class AdminEventsScreen extends StatefulWidget {
  const AdminEventsScreen({super.key});

  @override
  State<AdminEventsScreen> createState() => _AdminEventsScreenState();
}

class _AdminEventsScreenState extends State<AdminEventsScreen> {
  final _adminEventsStore = AdminEventsStore();

  static const _errorMessage = 'Não foi possível carregar os eventos.';
  static const _emptyMessage = 'Nenhum evento cadastrado.';
  static const _searchHint = 'Pesquisar eventos';

  static const _columns = [
    AdminTableColumn('', width: 56),
    AdminTableColumn('Título'),
    AdminTableColumn('Data', width: 110),
    AdminTableColumn('Local', width: 220),
  ];

  Future<void> _openForm([Events? event]) async {
    await openAdminForm(context, AppRoutes.adminCreateEvent, extra: event);
    _adminEventsStore.refreshData();
  }

  List<Widget> _cells(Events event) => [
        AdminTableThumb(imageUrl: _adminEventsStore.mediaMap[event.id]?.media),
        AdminTableTitle(title: event.name ?? '-', subtitle: event.description),
        AdminTableText(event.date?.formattedDate()),
        AdminTableText(formattedLocation(event.address)),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AdminCreateFab.isVisible(context)
          ? AdminCreateFab(label: 'Novo Evento', onPressed: _openForm)
          : null,
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: AdminMobilePageScaffold(
          title: 'Gerenciar Eventos',
          subtitle: 'Selecione um evento para editar.',
          onBack: () => closeAdminPage(context, AppRoutes.admin),
          child: AdminEntityListSectionMobileVersion<Events>(
            store: _adminEventsStore,
            errorMessage: _errorMessage,
            emptyMessage: _emptyMessage,
            searchHint: _searchHint,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: EventTileMobileVersion.height,
            ),
            itemBuilder: (context, event) => EventTileMobileVersion(
              event: event,
              eventMedia: _adminEventsStore.mediaMap[event.id],
              onTap: () => _openForm(event),
              pinInfoToBottom: true,
            ),
          ),
        ),
        child: AdminDesktopShell(
          child: AdminEntityListSectionDesktopVersion<Events>(
            store: _adminEventsStore,
            title: 'Eventos',
            subtitle: 'Clique em uma linha para editar.',
            searchHint: _searchHint,
            errorMessage: _errorMessage,
            emptyMessage: _emptyMessage,
            createLabel: 'Novo evento',
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
