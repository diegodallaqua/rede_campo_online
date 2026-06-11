import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_row.dart';
import '../../../../features/events/models/events.dart';
import '../../../../features/events/models/events_media.dart';
import '../../../utils/formatters.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

class EventTileDesktopVersion extends StatelessWidget {
  final Events event;
  final EventMedia? eventMedia;
  final VoidCallback? onTap;
  final bool isAdmin;

  static const double coverHeight = 160.0;
  static const double borderRadius = 12.0;

  const EventTileDesktopVersion({
    super.key,
    required this.event,
    this.eventMedia,
    this.onTap,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = eventMedia?.media?.isNotEmpty == true;
    final description = event.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;

    final content = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              height: 3,
              color: isAdmin
                  ? CustomColors.copper_spice
                  : CustomColors.fresh_sprout),
          SizedBox(
            height: coverHeight,
            child: hasImage
                ? Image.network(
                    eventMedia!.media!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const ImagePlaceholder(),
                  )
                : const ImagePlaceholder(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name ?? '—',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: CustomColors.pine_shadow,
                          height: 1.3,
                        ),
                      ),
                      if (hasDescription) ...[
                        const SizedBox(height: 6),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: CustomColors.midnight_slate,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (event.date != null)
                        CustomRow(
                          icon: Icons.calendar_today_outlined,
                          text: event.date!.formattedDate(),
                          iconSize: 12,
                          fontSize: 12,
                        ),
                      const SizedBox(height: 3),
                      CustomRow(
                        icon: Icons.location_on_outlined,
                        text: formattedLocation(event.address),
                        iconSize: 12,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
