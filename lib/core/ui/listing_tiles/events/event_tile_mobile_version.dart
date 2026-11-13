import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_row.dart';

import '../../../../features/events/models/events.dart';
import '../../../../features/events/models/events_media.dart';
import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';
import '../tile_card.dart';

class EventTileMobileVersion extends StatelessWidget {
  final Events event;
  final EventMedia? eventMedia;
  final VoidCallback? onTap;

  final bool pinInfoToBottom;

  const EventTileMobileVersion({
    super.key,
    required this.event,
    this.eventMedia,
    this.onTap,
    this.pinInfoToBottom = false,
  });

  /// Altura que as listagens em grade e carrossel reservam para cada card.
  static const double height = 236.0;
  static const double _coverHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    final description = event.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;

    final titleAndDescription = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          event.name ?? '-',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: CustomTextStyles.cardTitleMobile.copyWith(
            fontSize: 14,
            color: CustomColors.pine_shadow,
          ),
        ),
        if (hasDescription) ...[
          const SizedBox(height: 3),
          Text(
            description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.meta.copyWith(
              fontSize: 12,
              color: CustomColors.midnight_slate,
            ),
          ),
        ],
      ],
    );

    final infoRows = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (event.date != null) ...[
          CustomRow(
            icon: Icons.calendar_today_outlined,
            text: event.date!.formattedDate(),
            textColor: CustomColors.midnight_slate,
            iconSize: 13,
            fontSize: 12,
          ),
          const SizedBox(height: 3),
        ],
        CustomRow(
          icon: Icons.location_on_outlined,
          text: formattedLocation(event.address),
          textColor: CustomColors.midnight_slate,
          iconSize: 13,
          fontSize: 12,
        ),
      ],
    );

    const textPadding = EdgeInsets.fromLTRB(10, 10, 10, 10);
    final textBody = pinInfoToBottom
        ? Expanded(
            child: Padding(
              padding: textPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  titleAndDescription,
                  infoRows,
                ],
              ),
            ),
          )
        : Padding(
            padding: textPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleAndDescription,
                const SizedBox(height: 6),
                infoRows,
              ],
            ),
          );

    return TileCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: pinInfoToBottom ? MainAxisSize.max : MainAxisSize.min,
        children: [
          TileCover(imageUrl: eventMedia?.media, height: _coverHeight),
          textBody,
        ],
      ),
    );
  }
}
