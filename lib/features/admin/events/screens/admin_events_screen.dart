import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/gradient_header.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_sidebar.dart';
import 'package:rede_campo_online/features/admin/stores/admin_store.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/events/event_tile_desktop_version.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/events/event_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_entity_list_section.dart';
import 'package:rede_campo_online/features/admin/events/stores/admin_events_store.dart';
import 'package:rede_campo_online/features/events/models/events.dart';

class AdminEventsScreen extends StatefulWidget {
  const AdminEventsScreen({super.key});

  @override
  State<AdminEventsScreen> createState() => _AdminEventsScreenState();
}

class _AdminEventsScreenState extends State<AdminEventsScreen> {
  final _adminEventsStore = AdminEventsStore();

  Future<void> _navigateToEdit(Events? event) async {
    await context.push(AppRoutes.adminCreateEvent, extra: event);
    _adminEventsStore.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final fab = FloatingActionButton.extended(
      onPressed: () => _navigateToEdit(null),
      backgroundColor: CustomColors.copper_spice,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.add_rounded, size: 22),
      label: const Text(
        'Novo Evento',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );

    return Scaffold(
      floatingActionButton: fab,
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: _buildMobile(context),
        child: _buildDesktop(context),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return ColoredBox(
      color: CustomColors.vanilla_haze.withOpacity(0.5),
      child: Row(
        children: [
          Observer(
            builder: (_) => AdminSidebar(store: getIt<AdminStore>()),
          ),
          Expanded(
            child: AdminEntityListSectionDesktopVersion<Events>(
              store: _adminEventsStore,
              title: 'Gerenciar Eventos',
              subtitle: 'Selecione um evento para editar.',
              errorMessage: 'Não foi possível carregar os eventos.',
              emptyMessage: 'Nenhum evento cadastrado.',
              itemBuilder: (context, event) => EventTileDesktopVersion(
                event: event,
                eventMedia: _adminEventsStore.mediaMap[event.id],
                onTap: () => _navigateToEdit(event),
                isAdmin: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColors.copper_spice, CustomColors.midnight_slate],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            GradientHeader(
              title: 'Gerenciar Eventos',
              subtitle: 'Selecione um evento para editar.',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: CustomColors.salt_flower,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                clipBehavior: Clip.antiAlias,
                child: AdminEntityListSectionMobileVersion<Events>(
                  store: _adminEventsStore,
                  errorMessage: 'Não foi possível carregar os eventos.',
                  emptyMessage: 'Nenhum evento cadastrado.',
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 215,
                  ),
                  itemBuilder: (context, event) => EventTileMobileVersion(
                    event: event,
                    eventMedia: _adminEventsStore.mediaMap[event.id],
                    onTap: () => _navigateToEdit(event),
                    pinInfoToBottom: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
