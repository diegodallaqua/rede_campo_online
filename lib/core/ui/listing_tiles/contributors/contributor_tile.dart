import 'package:flutter/material.dart';

import '../../../../core/utils/models/contributor.dart';
import '../../../global/constants/api_constants.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

class ContributorTile extends StatelessWidget {
  final Contributors contributor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const ContributorTile({
    super.key,
    required this.contributor,
    this.onTap,
    this.margin,
  });

  static const double _cardWidth = 160.0;
  static const double _avatarDiameter = 80.0;
  static const double _borderRadius = 14.0;
  static const Color _accentColor = CustomColors.fresh_sprout;

  bool get _isExternal => contributor.external_author != null;

  String get _name =>
      contributor.member?.name ?? contributor.external_author?.name ?? '—';

  bool get _hasValidPicture =>
      contributor.member?.profilePicture != null &&
      contributor.member!.profilePicture!.isNotEmpty;

  String get _pictureUrl {
    final url = contributor.member!.profilePicture!;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return '$baseURL/${url.startsWith('/') ? url.substring(1) : url}';
  }

  String? get _subInfo {
    final org = contributor.member?.organization?.name;
    if (org != null && org.isNotEmpty) return org;
    final orcid = contributor.external_author?.orcid;
    if (orcid != null && orcid.isNotEmpty) return orcid;
    return null;
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
            Container(height: 3, color: _accentColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: _AvatarRing(
                  diameter: _avatarDiameter,
                  ringColor: _accentColor,
                  child: _hasValidPicture
                      ? Image.network(
                          _pictureUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) =>
                              progress == null
                                  ? child
                                  : AvatarPlaceholder(
                                      name: _name,
                                      backgroundColor: _accentColor),
                          errorBuilder: (_, __, ___) => AvatarPlaceholder(
                              name: _name, backgroundColor: _accentColor),
                        )
                      : AvatarPlaceholder(
                          name: _name, backgroundColor: _accentColor),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: _cardWidth - 20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.pine_shadow,
                            height: 1.3,
                          ),
                        ),
                        if (contributor.contributor_role?.name != null) ...[
                          const SizedBox(height: 6),
                          _RoleBadge(
                            label: contributor.contributor_role!.name!,
                            color: _accentColor,
                          ),
                        ],
                        if (_subInfo != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _subInfo!,
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
                        if (_isExternal) ...[
                          const SizedBox(height: 5),
                          _ExternalBadge(),
                        ],
                      ],
                    ),
                  ),
                ),
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

class _ExternalBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: CustomColors.concrete_mist.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Externo',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: CustomColors.pine_shadow.withOpacity(0.5),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
