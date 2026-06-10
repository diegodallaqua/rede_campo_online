import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/widgets/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../models/thesis.dart';
import '../stores/thesis_details_store.dart';
import 'widgets/sections/authors_section/thesis_authors_section_desktop_version.dart';
import 'widgets/sections/authors_section/thesis_authors_section_mobile_version.dart';
import 'widgets/sections/content_section/thesis_content_section_desktop_version.dart';
import 'widgets/sections/content_section/thesis_content_section_mobile_version.dart';
import 'widgets/sections/header_section/thesis_header_section_desktop_version.dart';
import 'widgets/sections/header_section/thesis_header_section_mobile_version.dart';

class ThesisDetailsScreen extends StatefulWidget {
  final Thesis thesis;

  const ThesisDetailsScreen({super.key, required this.thesis});

  @override
  State<ThesisDetailsScreen> createState() => _ThesisDetailsScreenState();
}

class _ThesisDetailsScreenState extends State<ThesisDetailsScreen> {
  late final ThesisDetailsStore thesisDetailsStore;

  @override
  void initState() {
    super.initState();
    thesisDetailsStore = ThesisDetailsStore();
    thesisDetailsStore.fetchTranslation(
      widget.thesis.publication?.abstract ?? '',
    );
  }

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
              ThesisHeaderSectionMobileVersion(thesis: widget.thesis),
              ThesisContentSectionMobileVersion(
                thesis: widget.thesis,
                store: thesisDetailsStore,
              ),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: ThesisAuthorsSectionMobileVersion(thesis: widget.thesis),
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
              ThesisHeaderSectionDesktopVersion(thesis: widget.thesis),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ThesisContentSectionDesktopVersion(
                      thesis: widget.thesis,
                      store: thesisDetailsStore,
                    ),
                    ThesisAuthorsSectionDesktopVersion(thesis: widget.thesis),
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
