import 'package:flutter/material.dart';

import '../../../../features/events/models/events.dart';
import '../../../../features/events/models/events_media.dart';
import '../../../utils/formatters.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

class EventTileDesktopVersion extends StatelessWidget {
  final Events event;
  final EventMedia? eventMedia;
  final VoidCallback? onTap;

  static const double coverHeight = 150.0;
  static const double borderRadius = 12.0;

  const EventTileDesktopVersion({
    super.key,
    required this.event,
    this.eventMedia,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = eventMedia?.media?.isNotEmpty == true;
    final hasDescription = event.description?.isNotEmpty == true;

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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name ?? '—',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.pine_shadow,
                      height: 1.3,
                    ),
                  ),
                  if (hasDescription) ...[
                    const SizedBox(height: 6),
                    Text(
                      event.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.pine_shadow,
                        height: 1.45,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (event.date != null) ...[
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: event.date!.formattedDate(),
                    ),
                    const SizedBox(height: 4),
                  ],
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: formattedLocation(event.address),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: CustomColors.copper_spice),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: CustomColors.pine_shadow,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
