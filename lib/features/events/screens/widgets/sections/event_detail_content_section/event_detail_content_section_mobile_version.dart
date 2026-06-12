import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/ui/buttons/custom_button.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/utils/formatters.dart';
import '../../../../models/events.dart';

class EventDetailContentSectionMobileVersion extends StatelessWidget {
  final Events event;

  const EventDetailContentSectionMobileVersion({
    super.key,
    required this.event,
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
    final description = event.description?.trim() ?? '';
    final date = event.date?.formattedDate() ?? '';
    final hasRegistration =
        event.registration_url != null && event.registration_url!.isNotEmpty;

    if (description.isEmpty && date.isEmpty && !hasRegistration) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (description.isNotEmpty) ...[
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: CustomColors.vanilla_haze,
                height: 1.7,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
          ],
          if (date.isNotEmpty) ...[
            Text(
              'Data: $date',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: CustomColors.concrete_mist,
              ),
            ),
            if (event.date!.hasTime) ...[
              const SizedBox(height: 6),
              Text(
                'Horário: ${event.date!.formattedTime()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: CustomColors.concrete_mist,
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
          if (hasRegistration)
            CustomButton(
              width: double.infinity,
              color: CustomColors.fresh_sprout,
              textColor: CustomColors.vanilla_haze,
              text: 'Inscreva-se',
              borderRadius: 10,
              fontWeight: FontWeight.w700,
              function: _openRegistrationUrl,
            ),
        ],
      ),
    );
  }
}
