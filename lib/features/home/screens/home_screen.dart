import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/layout/footer.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../features/news/stores/news_store.dart';
import '../../../core/ui/layout/custom_app_bar.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../../publications/stores/publications_store.dart';
import '../widgets/sections/about_section_desktop_version.dart';
import '../widgets/sections/about_section_mobile_version.dart';
import '../widgets/sections/header_section_desktop_version.dart';
import '../widgets/sections/header_section_mobile_version.dart';
import '../widgets/sections/news_section_desktop_version.dart';
import '../widgets/sections/news_section_mobile_version.dart';
import '../widgets/sections/partners_section_desktop_version.dart';
import '../widgets/sections/partners_section_mobile_version.dart';
import '../widgets/sections/publications_section_desktop_version.dart';
import '../widgets/sections/publications_section_mobile_version.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsStore newsStore = NewsStore();
    final PublicationsStore publicationsStore = PublicationsStore();

    return Scaffold(
      backgroundColor: CustomColors.vanilla_haze,
      appBar: const CustomAppBar(),
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HeaderSectionMobileVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AboutSectionMobileVersion(),
                    NewsSectionMobileVersion(newsStore: newsStore),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              PublicationsSectionMobileVersion(
                  publicationsStore: publicationsStore),
              const PartnersSectionMobileVersion(),
              const Footer(),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HeaderSectionDesktopVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AboutSectionDesktopVersion(),
                    NewsSectionDesktopVersion(newsStore: newsStore),
                  ],
                ),
              ),
              PublicationsSectionDesktopVersion(
                  publicationsStore: publicationsStore),
              const PartnersSectionDesktopVersion(),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
