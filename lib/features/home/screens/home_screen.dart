import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/layout/footer.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../features/news/stores/news_store.dart';
import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../../publications/stores/publications_store.dart';
import 'widgets/sections/about_us_section/home_about_us_section_desktop_version.dart';
import 'widgets/sections/about_us_section/home_about_us_section_mobile_version.dart';
import 'widgets/sections/header_section/home_header_section_desktop_version.dart';
import 'widgets/sections/header_section/home_header_section_mobile_version.dart';
import 'widgets/sections/recent_news_section/home_recent_news_section_desktop_version.dart';
import 'widgets/sections/recent_news_section/home_recent_news_section_mobile_version.dart';
import 'widgets/sections/partners_section/home_partners_section_desktop_version.dart';
import 'widgets/sections/partners_section/home_partners_section_mobile_version.dart';
import 'widgets/sections/recent_publications_section/home_recent_publications_section_desktop_version.dart';
import 'widgets/sections/recent_publications_section/home_recent_publications_section_mobile_version.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Stores no State: criadas no build, cada rebuild geraria instâncias novas
  // e as listagens ficariam presas à antiga.
  final NewsStore newsStore = NewsStore(loadList: false);
  final PublicationsStore publicationsStore = PublicationsStore();

  @override
  Widget build(BuildContext context) {
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
