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
import 'package:rede_campo_online/features/admin/news/screens/widgets/sections/admin_news_list_section/admin_news_list_section_desktop_version.dart';
import 'package:rede_campo_online/features/admin/news/screens/widgets/sections/admin_news_list_section/admin_news_list_section_mobile_version.dart';
import 'package:rede_campo_online/features/admin/news/stores/admin_news_store.dart';
import 'package:rede_campo_online/features/news/models/news.dart';

class AdminNewsScreen extends StatefulWidget {
  const AdminNewsScreen({super.key});

  @override
  State<AdminNewsScreen> createState() => _AdminNewsScreenState();
}

class _AdminNewsScreenState extends State<AdminNewsScreen> {
  final _adminNewsStore = AdminNewsStore();

  Future<void> _navigateToEdit(News? news) async {
    await context.push(AppRoutes.adminCreateNews, extra: news);
    _adminNewsStore.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveWrapper.of(context).isLargerThan(TABLET);

    final fab = FloatingActionButton.extended(
      onPressed: () => _navigateToEdit(null),
      backgroundColor: CustomColors.copper_spice,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.add_rounded, size: 22),
      label: const Text(
        'Nova Notícia',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: CustomColors.vanilla_haze.withOpacity(0.5),
        floatingActionButton: fab,
        body: Row(
          children: [
            Observer(
              builder: (_) => AdminSidebar(store: getIt<AdminStore>()),
            ),
            Expanded(
              child: AdminNewsListSectionDesktopVersion(
                adminNewsStore: _adminNewsStore,
                onTapNews: _navigateToEdit,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: fab,
      body: Container(
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
                title: 'Gerenciar Notícias',
                subtitle: 'Selecione uma notícia para editar.',
                onBack: () => context.pop(),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: CustomColors.salt_flower,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AdminNewsListSectionMobileVersion(
                    adminNewsStore: _adminNewsStore,
                    onTapNews: _navigateToEdit,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
