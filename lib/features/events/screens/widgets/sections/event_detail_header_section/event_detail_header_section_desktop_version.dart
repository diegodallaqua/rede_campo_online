import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/ui/buttons/custom_button.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/dialogs/image_viewer_dialog.dart';
import '../../../../../../core/utils/formatters.dart';
import '../../../../../../core/utils/placeholders.dart';
import '../../../../models/events.dart';
import '../../../../stores/event_detail_store.dart';

class EventDetailHeaderSectionDesktopVersion extends StatelessWidget {
  final Events event;
  final EventDetailStore eventDetailStore;

  const EventDetailHeaderSectionDesktopVersion({
    super.key,
    required this.event,
    required this.eventDetailStore,
  });

  Future<void> _openRegistrationUrl() async {
    final url = event.registration_url;
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank');
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = event.date?.formattedDate() ?? '';
    final hasRegistration =
        event.registration_url != null && event.registration_url!.isNotEmpty;

    return Container(
      color: CustomColors.vanilla_haze,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name ?? '-',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: CustomColors.midnight_slate,
                          fontFamily: 'RobotoSlab',
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 56,
                        height: 4,
                        decoration: BoxDecoration(
                          color: CustomColors.copper_spice,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      if (date.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: CustomColors.copper_spice,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Data: $date',
                              style: const TextStyle(
                                fontSize: 14,
                                color: CustomColors.pine_shadow,
                              ),
                            ),
                          ],
                        ),
                        if (event.date!.hasTime) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_outlined,
                                size: 15,
                                color: CustomColors.copper_spice,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Horário: ${event.date!.formattedTime()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.pine_shadow,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                      if (hasRegistration) ...[
                        const SizedBox(height: 32),
                        CustomButton(
                          width: 220,
                          color: CustomColors.fresh_sprout,
                          textColor: CustomColors.vanilla_haze,
                          text: 'Inscreva-se',
                          borderRadius: 10,
                          fontWeight: FontWeight.w700,
                          function: _openRegistrationUrl,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 64),
                Expanded(
                  flex: 4,
                  child: Observer(
                    builder: (context) {
                      final viewable = eventDetailStore.media
                          .where((m) => m.media?.isNotEmpty == true)
                          .toList();
                      final cover = viewable.isNotEmpty ? viewable.first : null;

                      final image = AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: cover != null
                              ? Image.network(
                                  cover.media!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const ImagePlaceholder(),
                                )
                              : const ImagePlaceholder(),
                        ),
                      );

                      if (cover == null) return image;

                      return GestureDetector(
                        onTap: () => ImageViewerDialog.show(
                          context: context,
                          imageUrls: viewable.map((m) => m.media!).toList(),
                          imageNames: viewable.map((m) => m.name).toList(),
                          initialIndex: 0,
                        ),
                        child: image,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
