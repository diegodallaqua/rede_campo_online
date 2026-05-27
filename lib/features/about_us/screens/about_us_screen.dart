import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/layout/footer.dart';
import 'package:rede_campo_online/features/about_us/screens/widgets/sections/content_section/about_us_content_section_desktop_version.dart';
import 'package:rede_campo_online/features/about_us/screens/widgets/sections/content_section/about_us_content_section_mobile_version.dart';
import 'package:rede_campo_online/features/about_us/screens/widgets/sections/header_section/about_us_header_section_desktop_version.dart';
import 'package:rede_campo_online/features/about_us/screens/widgets/sections/header_section/about_us_header_section_mobile_version.dart';
import 'package:rede_campo_online/features/about_us/screens/widgets/sections/history_section/about_us_history_section_desktop_version.dart';
import 'package:rede_campo_online/features/about_us/screens/widgets/sections/history_section/about_us_history_section_mobile_version.dart';
import 'package:rede_campo_online/features/about_us/screens/widgets/sections/members_section/about_us_members_section_desktop_version.dart';
import 'package:rede_campo_online/features/about_us/screens/widgets/sections/members_section/about_us_members_section_mobile_version.dart';
import 'package:rede_campo_online/features/about_us/screens/widgets/sections/partners_section/about_us_partners_section_desktop_version.dart';
import 'package:rede_campo_online/features/about_us/screens/widgets/sections/partners_section/about_us_partners_section_mobile_version.dart';
import 'package:rede_campo_online/features/members/stores/members_store.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/theme/custom_colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MembersStore membersStore = MembersStore();

    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AboutUsHeaderSectionMobileVersion(),
              const ColoredBox(
                color: CustomColors.midnight_slate,
                child: AboutUsContentSectionMobileVersion(),
              ),
              const AboutUsHistorySectionMobileVersion(),
              AboutUsMembersSectionMobileVersion(membersStore: membersStore),
              const AboutUsPartnersSectionMobileVersion(),
              const Footer(),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AboutUsHeaderSectionDesktopVersion(),
              const ColoredBox(
                color: CustomColors.midnight_slate,
                child: AboutUsContentSectionDesktopVersion(),
              ),
              const AboutUsHistorySectionDesktopVersion(),
              AboutUsMembersSectionDesktopVersion(membersStore: membersStore),
              const AboutUsPartnersSectionDesktopVersion(),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
