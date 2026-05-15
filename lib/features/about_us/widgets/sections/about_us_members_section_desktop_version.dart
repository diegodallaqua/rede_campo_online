import 'package:flutter/material.dart';

import '../../../../core/ui/theme/custom_colors.dart';
import '../../../members/stores/members_store.dart';
import '../listing/members_list_widget.dart';

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
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Nossa Equipe',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.copper_spice,
                ),
              ),
              const SizedBox(height: 32),
              MembersListWidget(membersStore: membersStore),
            ],
          ),
        ),
      ),
    );
  }
}
