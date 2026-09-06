import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/sections/abstract_section.dart';
import '../../../core/ui/sections/authors_section.dart';
import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/widgets/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/stores/translation_store.dart';
import '../models/academic_work.dart';
import 'widgets/sections/header_section/academic_work_header_section_desktop_version.dart';
import 'widgets/sections/header_section/academic_work_header_section_mobile_version.dart';

class AcademicWorkDetailsScreen extends StatefulWidget {
  final AcademicWork academicWork;

  const AcademicWorkDetailsScreen({super.key, required this.academicWork});

  @override
  State<AcademicWorkDetailsScreen> createState() =>
      _AcademicWorkDetailsScreenState();
}

class _AcademicWorkDetailsScreenState extends State<AcademicWorkDetailsScreen> {
  late final TranslationStore translationStore;

  static const _authorsTitle = 'Autores do Trabalho';
  static const _authorsEmptyMessage =
      'Nenhum autor vinculado a este trabalho.';

  @override
  void initState() {
    super.initState();
    translationStore = TranslationStore();
    translationStore.fetchTranslation(
      widget.academicWork.publication?.abstract ?? '',
    );
  }

  String get _publishedLabel {
    final parts = <String>[];
    final org = widget.academicWork.organization?.name ?? '';
    final date = widget.academicWork.publication?.publication_date;
    if (org.isNotEmpty) parts.add(org);
    if (date != null) {
      final dateStr = date.formattedDate();
      if (dateStr.isNotEmpty) parts.add(dateStr);
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final abstractText = widget.academicWork.publication?.abstract ?? '';
    final contributors = widget.academicWork.publication?.contributors ?? [];

    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AcademicWorkHeaderSectionMobileVersion(
                academicWork: widget.academicWork,
              ),
              AbstractSectionMobileVersion(
                abstractText: abstractText,
                store: translationStore,
                publishedLabel: _publishedLabel,
                researchAreas:
                    widget.academicWork.publication?.research_areas ?? [],
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
              AcademicWorkHeaderSectionDesktopVersion(
                academicWork: widget.academicWork,
              ),
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
