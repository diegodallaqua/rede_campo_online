import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../stores/paged_store.dart';
import 'admin_entity_list.dart';
import 'admin_search_bar.dart';
import 'admin_section_header.dart';

/// Seção desktop das telas de gerenciamento do painel administrativo:
/// cabeçalho (voltar/título/subtítulo), busca e listagem paginada genérica.
class AdminEntityListSectionDesktopVersion<T> extends StatefulWidget {
  final PagedStore<T> store;
  final String title;
  final String subtitle;
  final String errorMessage;
  final String emptyMessage;
  final AdminEntityItemBuilder<T> itemBuilder;
  final SliverGridDelegate gridDelegate;

  const AdminEntityListSectionDesktopVersion({
    super.key,
    required this.store,
    required this.title,
    required this.subtitle,
    required this.errorMessage,
    required this.emptyMessage,
    required this.itemBuilder,
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 6,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      mainAxisExtent: 310,
    ),
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
          onBack: () => context.pop(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: AdminSearchBar(
            controller: _searchController,
            onSubmitted: _onSearch,
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
            itemBuilder: widget.itemBuilder,
            gridDelegate: widget.gridDelegate,
          ),
        ),
      ],
    );
  }
}

/// Seção mobile das telas de gerenciamento do painel administrativo:
/// busca e listagem com rolagem infinita.
class AdminEntityListSectionMobileVersion<T> extends StatefulWidget {
  final PagedStore<T> store;
  final String errorMessage;
  final String emptyMessage;
  final AdminEntityItemBuilder<T> itemBuilder;
  final SliverGridDelegate? gridDelegate;

  const AdminEntityListSectionMobileVersion({
    super.key,
    required this.store,
    required this.errorMessage,
    required this.emptyMessage,
    required this.itemBuilder,
    this.gridDelegate,
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
