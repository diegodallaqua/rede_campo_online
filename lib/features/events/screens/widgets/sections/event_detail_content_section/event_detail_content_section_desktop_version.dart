import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/events.dart';

class EventDetailContentSectionDesktopVersion extends StatelessWidget {
  final Events event;

  const EventDetailContentSectionDesktopVersion({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final description = event.description?.trim() ?? '';
    if (description.isEmpty) return const SizedBox.shrink();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 56, 48, 48),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 17,
              color: CustomColors.vanilla_haze,
              height: 1.8,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
