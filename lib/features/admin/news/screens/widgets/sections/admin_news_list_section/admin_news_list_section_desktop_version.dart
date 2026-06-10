import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/admin/news/screens/widgets/listing/admin_news/admin_news_list_widget_desktop_version.dart';
import 'package:rede_campo_online/features/admin/news/stores/admin_news_store.dart';
import 'package:rede_campo_online/features/news/models/news.dart';

class AdminNewsListSectionDesktopVersion extends StatefulWidget {
  final AdminNewsStore adminNewsStore;
  final Future<void> Function(News? news) onTapNews;

  const AdminNewsListSectionDesktopVersion({
    super.key,
    required this.adminNewsStore,
    required this.onTapNews,
  });

  @override
  State<AdminNewsListSectionDesktopVersion> createState() =>
      _AdminNewsListSectionDesktopVersionState();
}

class _AdminNewsListSectionDesktopVersionState
    extends State<AdminNewsListSectionDesktopVersion> {
  int _maxDiscoveredPage = 1;

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
                'Gerenciar Notícias',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.pine_shadow,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecione uma notícia para editar.',
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.pine_shadow.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: AdminNewsListWidgetDesktopVersion(
            adminNewsStore: widget.adminNewsStore,
            maxDiscoveredPage: _maxDiscoveredPage,
            onPageDiscovered: (newMax) {
              if (newMax != _maxDiscoveredPage) {
                setState(() => _maxDiscoveredPage = newMax);
              }
            },
            onTapNews: widget.onTapNews,
          ),
        ),
      ],
    );
  }
}
