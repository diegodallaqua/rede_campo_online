import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/thesis.dart';

class ThesisHeaderSectionMobileVersion extends StatelessWidget {
  final Thesis thesis;

  const ThesisHeaderSectionMobileVersion({
    super.key,
    required this.thesis,
  });

  @override
  Widget build(BuildContext context) {
    final title = thesis.publication?.title ?? '-';
    final doi = thesis.publication?.doi ?? '';

    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              fontFamily: 'RobotoSlab',
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          if (doi.isNotEmpty) ...[
            const SizedBox(height: 12),
            _DoiLink(doi: doi),
          ],
        ],
      ),
    );
  }
}

class _DoiLink extends StatelessWidget {
  final String doi;

  const _DoiLink({required this.doi});

  String get _resolvedUrl =>
      doi.startsWith('http') ? doi : 'https://doi.org/$doi';

  Future<void> _open() async {
    final uri = Uri.tryParse(_resolvedUrl);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _open,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DOI: ',
            style: TextStyle(
              fontSize: 13,
              color: CustomColors.pine_shadow,
            ),
          ),
          Flexible(
            child: Text(
              doi,
              style: const TextStyle(
                fontSize: 13,
                color: CustomColors.fresh_sprout,
                decoration: TextDecoration.underline,
                decorationColor: CustomColors.fresh_sprout,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
