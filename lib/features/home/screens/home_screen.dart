import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/layout/footer.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../features/news/stores/news_store.dart';
import '../../../core/ui/layout/app_scaffold.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../../publications/stores/publications_store.dart';
import 'widgets/sections/home_about_us_section_desktop_version.dart';
import 'widgets/sections/home_about_us_section_mobile_version.dart';
import 'widgets/sections/home_header_section_desktop_version.dart';
import 'widgets/sections/home_header_section_mobile_version.dart';
import 'widgets/sections/home_recent_news_section_desktop_version.dart';
import 'widgets/sections/home_recent_news_section_mobile_version.dart';
import 'widgets/sections/home_partners_section_desktop_version.dart';
import 'widgets/sections/home_partners_section_mobile_version.dart';
import 'widgets/sections/home_recent_publications_section_desktop_version.dart';
import 'widgets/sections/home_recent_publications_section_mobile_version.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsStore newsStore = NewsStore();
    final PublicationsStore publicationsStore = PublicationsStore();

    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeHeaderSectionMobileVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const HomeAboutUsSectionMobileVersion(),
                    HomeRecentNewsSectionMobileVersion(newsStore: newsStore),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              HomeRecentPublicationsSectionMobileVersion(
                  publicationsStore: publicationsStore),
              const HomePartnersSectionMobileVersion(),
              const Footer(),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeHeaderSectionDesktopVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const HomeAboutUsSectionDesktopVersion(),
                    HomeRecentNewsSectionDesktopVersion(newsStore: newsStore),
                  ],
                ),
              ),
              HomeRecentPublicationsSectionDesktopVersion(
                  publicationsStore: publicationsStore),
              const HomePartnersSectionDesktopVersion(),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
