import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/admin/events/screens/widgets/listing/admin_events/admin_events_list_widget_mobile_version.dart';
import 'package:rede_campo_online/features/admin/events/stores/admin_events_store.dart';
import 'package:rede_campo_online/features/events/models/events.dart';

class AdminEventsListSectionMobileVersion extends StatefulWidget {
  final AdminEventsStore adminEventsStore;
  final Future<void> Function(Events? event) onTapEvent;

  const AdminEventsListSectionMobileVersion({
    super.key,
    required this.adminEventsStore,
    required this.onTapEvent,
  });

  @override
  State<AdminEventsListSectionMobileVersion> createState() =>
      _AdminEventsListSectionMobileVersionState();
}

class _AdminEventsListSectionMobileVersionState
    extends State<AdminEventsListSectionMobileVersion> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.adminEventsStore.filterStore.setSearch(value);
    widget.adminEventsStore.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
          child: AdminEventsListWidgetMobileVersion(
            adminEventsStore: widget.adminEventsStore,
            onTapEvent: widget.onTapEvent,
          ),
        ),
      ],
    );
  }
}
