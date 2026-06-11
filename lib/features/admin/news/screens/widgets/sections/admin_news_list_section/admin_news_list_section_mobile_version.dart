import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/admin/news/screens/widgets/listing/admin_news/admin_news_list_widget_mobile_version.dart';
import 'package:rede_campo_online/features/admin/news/stores/admin_news_store.dart';
import 'package:rede_campo_online/features/news/models/news.dart';

class AdminNewsListSectionMobileVersion extends StatefulWidget {
  final AdminNewsStore adminNewsStore;
  final Future<void> Function(News? news) onTapNews;

  const AdminNewsListSectionMobileVersion({
    super.key,
    required this.adminNewsStore,
    required this.onTapNews,
  });

  @override
  State<AdminNewsListSectionMobileVersion> createState() =>
      _AdminNewsListSectionMobileVersionState();
}

class _AdminNewsListSectionMobileVersionState
    extends State<AdminNewsListSectionMobileVersion> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.adminNewsStore.filterStore.setSearch(value);
    widget.adminNewsStore.refreshData();
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
          child: AdminNewsListWidgetMobileVersion(
            adminNewsStore: widget.adminNewsStore,
            onTapNews: widget.onTapNews,
          ),
        ),
      ],
    );
  }
}
