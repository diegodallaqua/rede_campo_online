import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/admin/events/screens/widgets/listing/admin_events/admin_events_list_widget_desktop_version.dart';
import 'package:rede_campo_online/features/admin/events/stores/admin_events_store.dart';
import 'package:rede_campo_online/features/events/models/events.dart';

class AdminEventsListSectionDesktopVersion extends StatefulWidget {
  final AdminEventsStore adminEventsStore;
  final Future<void> Function(Events? event) onTapEvent;

  const AdminEventsListSectionDesktopVersion({
    super.key,
    required this.adminEventsStore,
    required this.onTapEvent,
  });

  @override
  State<AdminEventsListSectionDesktopVersion> createState() =>
      _AdminEventsListSectionDesktopVersionState();
}

class _AdminEventsListSectionDesktopVersionState
    extends State<AdminEventsListSectionDesktopVersion> {
  final TextEditingController _searchController = TextEditingController();
  int _maxDiscoveredPage = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.adminEventsStore.filterStore.setSearch(value);
    widget.adminEventsStore.refreshData();
    setState(() => _maxDiscoveredPage = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: const Text('Painel Admin'),
                style: TextButton.styleFrom(
                  foregroundColor:
                      CustomColors.midnight_slate.withOpacity(0.50),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Gerenciar Eventos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.pine_shadow,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecione um evento para editar.',
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.pine_shadow.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: CustomSearchBar(
            controller: _searchController,
            onSubmitted: _onSearch,
            backgroundColor: Colors.white,
            borderColor: CustomColors.concrete_mist,
            textColor: CustomColors.midnight_slate,
            hintColor: CustomColors.midnight_slate.withOpacity(0.45),
            iconColor: CustomColors.copper_spice,
          ),
        ),
        Expanded(
          child: AdminEventsListWidgetDesktopVersion(
            adminEventsStore: widget.adminEventsStore,
            maxDiscoveredPage: _maxDiscoveredPage,
            onPageDiscovered: (newMax) {
              if (newMax != _maxDiscoveredPage) {
                setState(() => _maxDiscoveredPage = newMax);
              }
            },
            onTapEvent: widget.onTapEvent,
          ),
        ),
      ],
    );
  }
}
