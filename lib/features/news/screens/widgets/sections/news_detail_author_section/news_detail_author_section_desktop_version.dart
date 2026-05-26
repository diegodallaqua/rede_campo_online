import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/utils/placeholders.dart';
import '../../../../models/news.dart';

class NewsDetailAuthorSectionDesktopVersion extends StatelessWidget {
  final News news;

  const NewsDetailAuthorSectionDesktopVersion({
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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 48, 48, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text(
                    'Autor',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.copper_spice,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.copper_spice.withOpacity(0.4),
                            CustomColors.copper_spice.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: hasAvatar
                          ? Image.network(
                              member.profilePicture!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => AvatarPlaceholder(
                                  name: member.name,
                                  backgroundColor: CustomColors.copper_spice),
                            )
                          : AvatarPlaceholder(
                              name: member.name,
                              backgroundColor: CustomColors.copper_spice),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name ?? '—',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.pine_shadow,
                            height: 1.2,
                          ),
                        ),
                        if (member.description?.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          Text(
                            member.description!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: CustomColors.pine_shadow,
                              height: 1.6,
                            ),
                          ),
                        ],
                        if (roleName.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            roleName,
                            style: const TextStyle(
                              fontSize: 13,
                              color: CustomColors.copper_spice,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        if (orgName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            orgName,
                            style: const TextStyle(
                              fontSize: 13,
                              color: CustomColors.pine_shadow,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
