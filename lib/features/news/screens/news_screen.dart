import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/layout/footer.dart';
import 'package:rede_campo_online/core/ui/layout/app_scaffold.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/news/screens/widgets/sections/header_section/news_header_section_desktop_version.dart';
import 'package:rede_campo_online/features/news/screens/widgets/sections/header_section/news_header_section_mobile_version.dart';
import 'package:rede_campo_online/features/news/screens/widgets/sections/news_list_section/news_list_section_desktop_version.dart';
import 'package:rede_campo_online/features/news/screens/widgets/sections/news_list_section/news_list_section_mobile_version.dart';
import 'package:rede_campo_online/features/news/stores/news_store.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsStore newsStoreMobile = NewsStore(pageSize: 4);
    final NewsStore newsStoreDesktop = NewsStore(pageSize: 4);

    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const NewsHeaderSectionMobileVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    NewsListSectionMobileVersion(newsStore: newsStoreMobile),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Footer(),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const NewsHeaderSectionDesktopVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    NewsListSectionDesktopVersion(newsStore: newsStoreDesktop),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
