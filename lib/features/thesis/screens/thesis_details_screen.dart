import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/sections/abstract_section.dart';
import '../../../core/ui/sections/authors_section.dart';
import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/widgets/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/stores/translation_store.dart';
import '../models/thesis.dart';
import 'widgets/sections/header_section/thesis_header_section_desktop_version.dart';
import 'widgets/sections/header_section/thesis_header_section_mobile_version.dart';

class ThesisDetailsScreen extends StatefulWidget {
  final Thesis thesis;

  const ThesisDetailsScreen({super.key, required this.thesis});

  @override
  State<ThesisDetailsScreen> createState() => _ThesisDetailsScreenState();
}

class _ThesisDetailsScreenState extends State<ThesisDetailsScreen> {
  late final TranslationStore translationStore;

  static const _authorsTitle = 'Autores da Dissertação';
  static const _authorsEmptyMessage =
      'Nenhum autor vinculado a esta dissertação.';

  @override
  void initState() {
    super.initState();
    translationStore = TranslationStore();
    translationStore.fetchTranslation(
      widget.thesis.publication?.abstract ?? '',
    );
  }

  String get _publishedLabel {
    final parts = <String>[];
    final org = widget.thesis.organization?.name ?? '';
    final date = widget.thesis.publication?.publication_date;
    if (org.isNotEmpty) parts.add(org);
    if (date != null) {
      final dateStr = date.formattedDate();
      if (dateStr.isNotEmpty) parts.add(dateStr);
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final abstractText = widget.thesis.publication?.abstract ?? '';
    final contributors = widget.thesis.publication?.contributors ?? [];

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
              AbstractSectionMobileVersion(
                abstractText: abstractText,
                store: translationStore,
                publishedLabel: _publishedLabel,
                researchAreas: widget.thesis.publication?.research_areas ?? [],
              ),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: AuthorsSectionMobileVersion(
                  title: _authorsTitle,
                  emptyMessage: _authorsEmptyMessage,
                  contributors: contributors,
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
              ThesisHeaderSectionDesktopVersion(thesis: widget.thesis),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AbstractSectionDesktopVersion(
                      abstractText: abstractText,
                      store: translationStore,
                    ),
                    AuthorsSectionDesktopVersion(
                      title: _authorsTitle,
                      emptyMessage: _authorsEmptyMessage,
                      contributors: contributors,
                    ),
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
