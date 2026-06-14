import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/contributor.dart';
import '../../../../features/members/models/members.dart';
import '../../../global/constants/api_constants.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

/// Cartão de detalhes que exibe todas as informações de um membro (ou autor
/// externo) ao tocar em um [MemberTile]/[ContributorTile]. Usado nas telas de
/// detalhe — Sobre Nós, Projeto, Artigo, Livro, Capítulo e Dissertação.
class MemberDetailsDialog extends StatelessWidget {
  final String? name;
  final String? roleLabel;
  final String? organization;
  final String? email;
  final String? description;
  final String? lattesUrl;
  final String? linkedInUrl;
  final String? orcid;
  final bool isExternal;
  final String? profilePictureUrl;
  final Color accentColor;

  const MemberDetailsDialog({
    super.key,
    this.name,
    this.roleLabel,
    this.organization,
    this.email,
    this.description,
    this.lattesUrl,
    this.linkedInUrl,
    this.orcid,
    this.isExternal = false,
    this.profilePictureUrl,
    this.accentColor = CustomColors.fresh_sprout,
  });

  // ── Public entry points ──────────────────────────────────────────────────

  /// Abre o cartão a partir de um [Members] (Sobre Nós, Projetos).
  static Future<void> showForMember(
    BuildContext context,
    Members member, {
    Color accentColor = CustomColors.fresh_sprout,
    String? roleLabel,
  }) {
    return _open(
      context,
      MemberDetailsDialog(
        name: member.name,
        roleLabel: roleLabel ?? member.memberRole?.name,
        organization: member.organization?.name,
        email: member.email,
        description: member.description,
        lattesUrl: member.lattesUrl,
        linkedInUrl: member.linkedInUrl,
        profilePictureUrl: _resolvePicture(member.profilePicture),
        accentColor: accentColor,
      ),
    );
  }

  /// Abre o cartão a partir de um [Contributors] (telas de publicação). Quando
  /// o contribuidor é externo (sem [Members]), exibe os dados do autor externo.
  static Future<void> showForContributor(
    BuildContext context,
    Contributors contributor, {
    Color accentColor = CustomColors.fresh_sprout,
  }) {
    final member = contributor.member;
    final role = contributor.contributor_role?.name;

    if (member != null) {
      return showForMember(
        context,
        member,
        accentColor: accentColor,
        roleLabel: role ?? member.memberRole?.name,
      );
    }

    final external = contributor.external_author;
    return _open(
      context,
      MemberDetailsDialog(
        name: external?.name,
        roleLabel: role,
        email: external?.email,
        orcid: external?.orcid,
        isExternal: true,
        accentColor: accentColor,
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static Future<void> _open(BuildContext context, Widget dialog) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar',
      barrierColor: Colors.black.withOpacity(0.55),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => dialog,
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  static String? _resolvePicture(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return '$baseURL/${url.startsWith('/') ? url.substring(1) : url}';
  }

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return (trimmed != null && trimmed.isNotEmpty) ? trimmed : null;
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final displayName = _clean(name) ?? '—';
    final role = _clean(roleLabel);
    final org = _clean(organization);
    final mail = _clean(email);
    final about = _clean(description);
    final lattes = _clean(lattesUrl);
    final linkedIn = _clean(linkedInUrl);
    final orc = _clean(orcid);

    final links = <Widget>[
      if (mail != null)
        _ContactRow(
          icon: Icons.email_outlined,
          label: mail,
          accentColor: accentColor,
          onTap: () => _launch('mailto:$mail'),
        ),
      if (lattes != null)
        _ContactRow(
          icon: Icons.school_outlined,
          label: 'Currículo Lattes',
          accentColor: accentColor,
          onTap: () => _launch(lattes),
        ),
      if (linkedIn != null)
        _ContactRow(
          icon: Icons.business_center_outlined,
          label: 'LinkedIn',
          accentColor: accentColor,
          onTap: () => _launch(linkedIn),
        ),
      if (orc != null)
        _ContactRow(
          icon: Icons.badge_outlined,
          label: 'ORCID: $orc',
          accentColor: accentColor,
          onTap: () => _launch(
            orc.startsWith('http') ? orc : 'https://orcid.org/$orc',
          ),
        ),
    ];

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 620),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Accent strip + close button ──────────────────────────
            Stack(
              children: [
                Container(height: 5, color: accentColor),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _CloseButton(
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _Avatar(
                      name: displayName,
                      pictureUrl: profilePictureUrl,
                      accentColor: accentColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      displayName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: CustomColors.pine_shadow,
                        height: 1.25,
                      ),
                    ),
                    if (role != null || isExternal) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (role != null)
                            _Badge(label: role, color: accentColor),
                          if (isExternal) const _ExternalBadge(),
                        ],
                      ),
                    ],
                    if (org != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        org,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: CustomColors.pine_shadow.withOpacity(0.6),
                          height: 1.35,
                        ),
                      ),
                    ],
                    if (about != null) ...[
                      const SizedBox(height: 20),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: CustomColors.soft_border,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          about,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.55,
                            color: CustomColors.pine_shadow.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                    if (links.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: CustomColors.soft_border,
                      ),
                      const SizedBox(height: 12),
                      for (int i = 0; i < links.length; i++) ...[
                        links[i],
                        if (i < links.length - 1) const SizedBox(height: 4),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(String raw) async {
    final uri = Uri.tryParse(raw);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String name;
  final String? pictureUrl;
  final Color accentColor;

  const _Avatar({
    required this.name,
    required this.pictureUrl,
    required this.accentColor,
  });

  static const double _diameter = 104.0;

  @override
  Widget build(BuildContext context) {
    const ringWidth = 3.0;
    const gap = 3.0;
    final hasPicture = pictureUrl != null && pictureUrl!.isNotEmpty;

    return Container(
      width: _diameter + (ringWidth + gap) * 2,
      height: _diameter + (ringWidth + gap) * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: accentColor, width: ringWidth),
      ),
      padding: const EdgeInsets.all(gap),
      child: ClipOval(
        child: SizedBox(
          width: _diameter,
          height: _diameter,
          child: hasPicture
              ? Image.network(
                  pictureUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : AvatarPlaceholder(
                          name: name, backgroundColor: accentColor),
                  errorBuilder: (_, __, ___) => AvatarPlaceholder(
                      name: name, backgroundColor: accentColor),
                )
              : AvatarPlaceholder(name: name, backgroundColor: accentColor),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: accentColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: CustomColors.pine_shadow,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.open_in_new_rounded,
                size: 15,
                color: CustomColors.pine_shadow.withOpacity(0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ExternalBadge extends StatelessWidget {
  const _ExternalBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: CustomColors.concrete_mist.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Externo',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: CustomColors.pine_shadow.withOpacity(0.55),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          child: Icon(
            Icons.close_rounded,
            size: 20,
            color: CustomColors.pine_shadow.withOpacity(0.55),
          ),
        ),
      ),
    );
  }
}
