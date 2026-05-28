import 'package:flutter/material.dart';

import '../../../../../../core/global/constants/api_constants.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/utils/placeholders.dart';
import '../../../../models/news.dart';

class NewsDetailAuthorSectionMobileVersion extends StatelessWidget {
  final News news;

  const NewsDetailAuthorSectionMobileVersion({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    final member = news.member;
    if (member == null) return const SizedBox.shrink();

    final hasAvatar = member.profilePicture?.isNotEmpty == true;
    final roleName = member.memberRole?.name ?? '';
    final orgName = member.organization?.name ?? '';

    String pictureUrl() {
      final url = member.profilePicture!;
      if (url.startsWith('http://') || url.startsWith('https://')) return url;
      return '$baseURL/${url.startsWith('/') ? url.substring(1) : url}';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Autor',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.copper_spice,
            ),
          ),
          const SizedBox(height: 20),
          ClipOval(
            child: SizedBox(
              width: 96,
              height: 96,
              child: hasAvatar
                  ? Image.network(
                      pictureUrl(),
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) =>
                          progress == null
                              ? child
                              : AvatarPlaceholder(
                                  name: member.name,
                                  backgroundColor: CustomColors.copper_spice),
                      errorBuilder: (_, __, ___) => AvatarPlaceholder(
                          name: member.name,
                          backgroundColor: CustomColors.copper_spice),
                    )
                  : AvatarPlaceholder(
                      name: member.name,
                      backgroundColor: CustomColors.copper_spice),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            member.name ?? '—',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CustomColors.pine_shadow,
            ),
          ),
          if (member.description?.isNotEmpty == true) ...[
            const SizedBox(height: 6),
            Text(
              member.description!,
              style: const TextStyle(
                fontSize: 13,
                color: CustomColors.pine_shadow,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (roleName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              roleName,
              style: const TextStyle(
                fontSize: 12,
                color: CustomColors.copper_spice,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (orgName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              orgName,
              style: const TextStyle(
                fontSize: 12,
                color: CustomColors.pine_shadow,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
