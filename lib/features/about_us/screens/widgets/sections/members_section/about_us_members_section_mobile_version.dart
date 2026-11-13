import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../members/stores/members_store.dart';
import '../../listing/members/about_us_members_list_widget.dart';

class AboutUsMembersSectionMobileVersion extends StatelessWidget {
  final MembersStore membersStore;

  const AboutUsMembersSectionMobileVersion({
    super.key,
    required this.membersStore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle.mobile(
              title: 'Nossa Equipe',
              color: CustomColors.copper_spice,
            ),
          ),
          const SizedBox(height: 12),
          AboutUsMembersListWidget(membersStore: membersStore),
        ],
      ),
    );
  }
}
