import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_row.dart';

import '../../../../features/events/models/events.dart';
import '../../../../features/events/models/events_media.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    const double coverHeight = 100.0;
    const double borderRadius = 12.0;

    final hasImage = eventMedia?.media != null && eventMedia!.media!.isNotEmpty;

    final description = event.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;

    final titleAndDescription = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          event.name ?? '—',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: CustomColors.pine_shadow,
            height: 1.3,
          ),
        ),
        if (hasDescription) ...[
          const SizedBox(height: 3),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w400,
              color: CustomColors.midnight_slate,
              height: 1.25,
            ),
          ),
        ],
      ],
    );

    final infoRows = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomRow(
          icon: Icons.calendar_today_outlined,
          text: event.date!.formattedDate(),
          iconSize: 11,
          fontSize: 11,
        ),
        const SizedBox(height: 2),
        CustomRow(
          icon: Icons.location_on_outlined,
          text: formattedLocation(event.address),
          iconSize: 11,
          fontSize: 11,
        ),
      ],
    );

    final textBody = pinInfoToBottom
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
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
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleAndDescription,
                const SizedBox(height: 4),
                infoRows,
              ],
            ),
          );

    final content = Container(
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            child: SizedBox(
              height: coverHeight,
              child: hasImage
                  ? Image.network(
                      eventMedia!.media!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ImagePlaceholder(),
                    )
                  : const ImagePlaceholder(),
            ),
          ),
          textBody,
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
