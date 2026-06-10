import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/thesis.dart';
import '../../listing/authors/thesis_authors_list_widget_mobile_version.dart';

class ThesisAuthorsSectionMobileVersion extends StatelessWidget {
  final Thesis thesis;

  const ThesisAuthorsSectionMobileVersion({
    super.key,
    required this.thesis,
  });

  @override
  Widget build(BuildContext context) {
    final contributors = thesis.publication?.contributors ?? [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Autores da Dissertação',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ThesisAuthorsListWidgetMobileVersion(contributors: contributors),
        ],
      ),
    );
  }
}
