import 'package:flutter/material.dart';
import '../../../../features/members/models/members.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

class MemberTile extends StatelessWidget {
  final Members member;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final Color mainColor;

  const MemberTile({
    super.key,
    required this.member,
    this.onTap,
    this.margin,
    this.mainColor = CustomColors.honey_cream,
  });

  bool get _hasValidPicture =>
      member.profilePicture != null && member.profilePicture!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 160.0;
    const double avatarDiameter = 88.0; // raio 44 * 2
    const double borderRadius = 12.0;
    const double titleFontSize = 14.0;
    const double textFontSize = 11.0;

    final content = Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: mainColor,
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
            child: Container(
              color: mainColor.withOpacity(0.12),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: ClipOval(
                  child: SizedBox(
                    width: avatarDiameter,
                    height: avatarDiameter,
                    child: _hasValidPicture
                        ? Image.network(
                            member.profilePicture!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                AvatarPlaceholder(name: member.name),
                          )
                        : AvatarPlaceholder(name: member.name),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  member.name ?? '—',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w900,
                    color: CustomColors.pine_shadow,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 5),
                if (member.memberRole?.name != null) ...[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: textFontSize,
                        color: CustomColors.pine_shadow,
                        height: 1.35,
                      ),
                      children: [
                        TextSpan(
                          text: member.memberRole!.name,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
                if (member.organization?.name != null) ...[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: textFontSize,
                        color: CustomColors.pine_shadow,
                        height: 1.35,
                      ),
                      children: [
                        TextSpan(
                          text: member.organization!.name,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
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
