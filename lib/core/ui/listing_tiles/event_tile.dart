import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import '../../../features/events/models/events.dart';
import '../../../features/events/models/events_media.dart';
import '../../utils/placeholders.dart';
import '../theme/custom_colors.dart';

class EventTile extends StatelessWidget {
  final Events event;
  final EventMedia? eventMedia;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const EventTile({
    super.key,
    required this.event,
    this.eventMedia,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 180.0;
    const double coverHeight = 120.0;
    const double borderRadius = 12.0;
    const double titleFontSize = 13.0;
    const double textFontSize = 11.0;

    final content = Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: CustomColors.honey_cream,
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
              child: eventMedia != null && eventMedia?.media != null && eventMedia!.media!.isNotEmpty
                  ? Image.network(
                    eventMedia!.media!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const ImagePlaceholder(),
              ) : const ImagePlaceholder(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  event.name ?? '—',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.pine_shadow,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 4),

                if (event.project?.name != null) ...[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: textFontSize,
                        color: CustomColors.pine_shadow,
                        height: 1.35,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Projeto: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: event.project!.name,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],

                const Divider(thickness: 0.5, height: 8),
                const SizedBox(height: 2),

                if (event.date != null) ...[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: textFontSize,
                        color: CustomColors.pine_shadow,
                        height: 1.35,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Data: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: event.date!.formattedDate(),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                ],


                if (event.address != null) ...[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: textFontSize,
                        color: CustomColors.pine_shadow,
                        height: 1.35,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Local: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: formattedAddress(event.address!),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: margin,
      child: onTap == null
          ? content
          : Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }
}