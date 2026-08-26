import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/events.dart';

class EventDetailHeaderSectionMobileVersion extends StatelessWidget {
  final Events event;

  const EventDetailHeaderSectionMobileVersion({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Text(
        event.name ?? '-',
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: CustomColors.copper_spice,
          fontFamily: 'RobotoSlab',
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
