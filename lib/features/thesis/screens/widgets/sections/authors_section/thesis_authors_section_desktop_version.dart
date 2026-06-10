import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/thesis.dart';
import '../../listing/authors/thesis_authors_list_widget_desktop_version.dart';

class ThesisAuthorsSectionDesktopVersion extends StatelessWidget {
  final Thesis thesis;

  const ThesisAuthorsSectionDesktopVersion({
    super.key,
    required this.thesis,
  });

  @override
  Widget build(BuildContext context) {
    final contributors = thesis.publication?.contributors ?? [];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 24, 48, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text(
                    'Autores da Dissertação',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.fresh_sprout,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.fresh_sprout.withOpacity(0.4),
                            CustomColors.fresh_sprout.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ThesisAuthorsListWidgetDesktopVersion(contributors: contributors),
            ],
          ),
        ),
      ),
    );
  }
}
