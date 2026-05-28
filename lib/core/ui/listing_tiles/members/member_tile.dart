import 'package:flutter/material.dart';

import '../../../../features/members/models/members.dart';
import '../../../global/constants/api_constants.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

class MemberTile extends StatelessWidget {
  final Members member;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  final Color accentColor;

  const MemberTile({
    super.key,
    required this.member,
    this.onTap,
    this.margin,
    this.accentColor = CustomColors.fresh_sprout,
  });

  static const double _cardWidth = 160.0;
  static const double _avatarDiameter = 80.0;
  static const double _borderRadius = 14.0;

  bool get _hasValidPicture =>
      member.profilePicture != null && member.profilePicture!.isNotEmpty;

  String get _pictureUrl {
    final url = member.profilePicture!;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return '$baseURL/${url.startsWith('/') ? url.substring(1) : url}';
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: _cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 3, color: accentColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: _AvatarRing(
                  diameter: _avatarDiameter,
                  ringColor: accentColor,
                  child: _hasValidPicture
                      ? Image.network(
                          _pictureUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) =>
                              progress == null
                                  ? child
                                  : AvatarPlaceholder(
                                      name: member.name,
                                      backgroundColor: accentColor),
                          errorBuilder: (_, __, ___) => AvatarPlaceholder(
                              name: member.name, backgroundColor: accentColor),
                        )
                      : AvatarPlaceholder(
                          name: member.name, backgroundColor: accentColor),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    member.name ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.pine_shadow,
                      height: 1.3,
                    ),
                  ),
                  if (member.memberRole?.name != null) ...[
                    const SizedBox(height: 6),
                    _RoleBadge(
                      label: member.memberRole!.name!,
                      color: accentColor,
                    ),
                  ],
                  if (member.organization?.name != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      member.organization!.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: CustomColors.pine_shadow.withOpacity(0.55),
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      margin: margin,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(_borderRadius),
              child: InkWell(
                borderRadius: BorderRadius.circular(_borderRadius),
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}

class _AvatarRing extends StatelessWidget {
  final double diameter;
  final Color ringColor;
  final Widget child;

  const _AvatarRing({
    required this.diameter,
    required this.ringColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const ringWidth = 2.5;
    const gap = 2.5;

    return Container(
      width: diameter + (ringWidth + gap) * 2,
      height: diameter + (ringWidth + gap) * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: ringWidth),
      ),
      padding: const EdgeInsets.all(gap),
      child: ClipOval(
        child: SizedBox(width: diameter, height: diameter, child: child),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _RoleBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
