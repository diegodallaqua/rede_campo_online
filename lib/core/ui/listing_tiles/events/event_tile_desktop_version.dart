import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_row.dart';
import '../../../../features/events/models/events.dart';
import '../../../../features/events/models/events_media.dart';
import '../../../utils/formatters.dart';
import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';
import '../tile_card.dart';

class EventTileDesktopVersion extends StatelessWidget {
  final Events event;
  final EventMedia? eventMedia;
  final VoidCallback? onTap;
  final bool isAdmin;

  /// Altura que as listagens reservam para cada card.
  static const double height = 350.0;
  static const double _coverHeight = 160.0;

  const EventTileDesktopVersion({
    super.key,
    required this.event,
    this.eventMedia,
    this.onTap,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final description = event.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;

    return TileCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TileCover(imageUrl: eventMedia?.media, height: _coverHeight),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.cardTitleDesktop.copyWith(
                      color: CustomColors.pine_shadow,
                    ),
                  ),
                  if (hasDescription) ...[
                    const SizedBox(height: 6),
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.meta.copyWith(
                        color: CustomColors.midnight_slate,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (event.date != null) ...[
                    CustomRow(
                      icon: Icons.calendar_today_outlined,
                      text: event.date!.formattedDate(),
                      textColor: CustomColors.midnight_slate,
                      fontSize: 13,
                      iconSize: 15,
                    ),
                    const SizedBox(height: 6),
                  ],
                  CustomRow(
                    icon: Icons.location_on_outlined,
                    text: formattedLocation(event.address),
                    textColor: CustomColors.midnight_slate,
                    fontSize: 13,
                    iconSize: 15,
                  ),
                ],
              ),
            ),
          ),
          if (!isAdmin) const TileReadMore(),
        ],
      ),
    );
  }
}
