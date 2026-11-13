import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../members/stores/members_store.dart';
import '../../listing/members/about_us_members_list_widget.dart';

class AboutUsMembersSectionDesktopVersion extends StatelessWidget {
  final MembersStore membersStore;

  const AboutUsMembersSectionDesktopVersion({
    super.key,
    required this.membersStore,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SectionTitle(
                title: 'Nossa Equipe',
                color: CustomColors.copper_spice,
                centered: true,
              ),
              const SizedBox(height: 32),
              AboutUsMembersListWidget(membersStore: membersStore),
            ],
          ),
        ),
      ),
    );
  }
}
