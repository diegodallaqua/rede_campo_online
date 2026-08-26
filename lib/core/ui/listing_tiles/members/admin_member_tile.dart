import 'package:flutter/material.dart';

import '../../../../features/members/models/members.dart';
import '../../../global/constants/api_constants.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';
import '../../widgets/custom_row.dart';

/// Tile de listagem de membros exclusivo do painel administrativo. Diferente
/// do [MemberTile] público (cartão vertical compacto), apresenta um cartão
/// horizontal denso em informação - avatar, nome, papel, organização e
/// e-mail - com faixa de destaque e ação de edição.
class AdminMemberTile extends StatelessWidget {
  final Members member;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final Color accentColor;

  const AdminMemberTile({
    super.key,
    required this.member,
    this.onTap,
    this.margin,
    this.accentColor = CustomColors.copper_spice,
  });

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
    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: CustomColors.midnight_slate.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                  child: Row(
                    children: [
                      _Avatar(
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
                                    name: member.name,
                                    backgroundColor: accentColor),
                              )
                            : AvatarPlaceholder(
                                name: member.name,
                                backgroundColor: accentColor),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: _details()),
                      const SizedBox(width: 4),
                      _EditAffordance(color: accentColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  Widget _details() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          member.name ?? '-',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: CustomColors.pine_shadow,
            height: 1.25,
          ),
        ),
        if (member.memberRole?.name != null) ...[
          const SizedBox(height: 6),
          _RoleBadge(label: member.memberRole!.name!, color: accentColor),
        ],
        if (member.organization?.name != null) ...[
          const SizedBox(height: 7),
          CustomRow(
            icon: Icons.apartment_outlined,
            text: member.organization!.name!,
            iconColor: CustomColors.neutral_gray,
            textColor: CustomColors.neutral_gray,
            iconSize: 13,
            fontSize: 12,
          ),
        ],
        if (member.email != null && member.email!.isNotEmpty) ...[
          const SizedBox(height: 4),
          CustomRow(
            icon: Icons.email_outlined,
            text: member.email!,
            iconColor: CustomColors.neutral_gray,
            textColor: CustomColors.neutral_gray,
            iconSize: 13,
            fontSize: 12,
          ),
        ],
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final Color ringColor;
  final Widget child;

  const _Avatar({required this.ringColor, required this.child});

  static const double _diameter = 54;

  @override
  Widget build(BuildContext context) {
    const ringWidth = 2.0;
    const gap = 2.0;

    return Container(
      width: _diameter + (ringWidth + gap) * 2,
      height: _diameter + (ringWidth + gap) * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: ringWidth),
      ),
      padding: const EdgeInsets.all(gap),
      child: ClipOval(
        child: SizedBox(width: _diameter, height: _diameter, child: child),
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _EditAffordance extends StatelessWidget {
  final Color color;

  const _EditAffordance({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: CustomColors.peach_cream,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.edit_outlined, size: 17, color: color),
    );
  }
}
