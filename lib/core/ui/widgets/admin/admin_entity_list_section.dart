import 'package:flutter/material.dart';

import '../../../stores/paged_store.dart';
import 'admin_entity_list.dart';
import 'admin_table.dart';
import 'admin_search_bar.dart';
import 'admin_section_header.dart';

/// Seção desktop de gerenciamento: cabeçalho, busca e tabela paginada.
class AdminEntityListSectionDesktopVersion<T> extends StatefulWidget {
  final PagedStore<T> store;
  final String title;
  final String subtitle;
  final String searchHint;
  final String errorMessage;
  final String emptyMessage;
  final String createLabel;
  final VoidCallback onCreate;
  final List<AdminTableColumn> columns;
  final AdminEntityCellsBuilder<T> cellsBuilder;
  final ValueChanged<T> onEdit;

  const AdminEntityListSectionDesktopVersion({
    super.key,
    required this.store,
    required this.title,
    required this.subtitle,
    required this.searchHint,
    required this.errorMessage,
    required this.emptyMessage,
    required this.createLabel,
    required this.onCreate,
    required this.columns,
    required this.cellsBuilder,
    required this.onEdit,
  });

  @override
  State<AdminEntityListSectionDesktopVersion<T>> createState() =>
      _AdminEntityListSectionDesktopVersionState<T>();
}

class _AdminEntityListSectionDesktopVersionState<T>
    extends State<AdminEntityListSectionDesktopVersion<T>> {
  final TextEditingController _searchController = TextEditingController();
  int _maxDiscoveredPage = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.store.filterStore.setSearch(value);
    widget.store.refreshData();
    setState(() => _maxDiscoveredPage = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminSectionHeader(
          title: widget.title,
          subtitle: widget.subtitle,
          actionLabel: widget.createLabel,
          onAction: widget.onCreate,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: AdminSearchBar(
            controller: _searchController,
            onSubmitted: _onSearch,
            hintText: widget.searchHint,
          ),
        ),
        Expanded(
          child: AdminEntityListDesktopVersion<T>(
            store: widget.store,
            maxDiscoveredPage: _maxDiscoveredPage,
            onPageDiscovered: (newMax) {
              if (newMax != _maxDiscoveredPage) {
                setState(() => _maxDiscoveredPage = newMax);
              }
            },
            errorMessage: widget.errorMessage,
            emptyMessage: widget.emptyMessage,
            columns: widget.columns,
            cellsBuilder: widget.cellsBuilder,
            onEdit: widget.onEdit,
          ),
        ),
      ],
    );
  }
}

/// Seção mobile de gerenciamento: busca e rolagem infinita.
class AdminEntityListSectionMobileVersion<T> extends StatefulWidget {
  final PagedStore<T> store;
  final String errorMessage;
  final String emptyMessage;
  final AdminEntityItemBuilder<T> itemBuilder;
  final SliverGridDelegate? gridDelegate;
  final String searchHint;

  const AdminEntityListSectionMobileVersion({
    super.key,
    required this.store,
    required this.errorMessage,
    required this.emptyMessage,
    required this.itemBuilder,
    this.gridDelegate,
    this.searchHint = 'Pesquisar',
  });

  @override
  State<AdminEntityListSectionMobileVersion<T>> createState() =>
      _AdminEntityListSectionMobileVersionState<T>();
}

class _AdminEntityListSectionMobileVersionState<T>
    extends State<AdminEntityListSectionMobileVersion<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.store.filterStore.setSearch(value);
    widget.store.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: AdminSearchBar(
            controller: _searchController,
            onSubmitted: _onSearch,
            hintText: widget.searchHint,
          ),
        ),
        Expanded(
          child: AdminEntityListMobileVersion<T>(
            store: widget.store,
            errorMessage: widget.errorMessage,
            emptyMessage: widget.emptyMessage,
            itemBuilder: widget.itemBuilder,
            gridDelegate: widget.gridDelegate,
          ),
        ),
      ],
    );
  }
}
