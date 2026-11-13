import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/partner.dart';
import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';

// Parceiros como nós de uma rede, no motivo do logo da Rede Campo.
// Pensado para fundo claro (vanilla_haze).

const Color _lineColor = Color(0x5925422B); // pine_shadow a 35%
const double _lineWidth = 2.0;
const double _nodeSize = 18.0;
const Duration _hoverDuration = Duration(milliseconds: 180);

Future<void> _openSite(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

String _domain(String url) =>
    (Uri.tryParse(url)?.host ?? url).replaceFirst(RegExp(r'^www\.'), '');

/// Nó da rede (desktop): círculo sobre a linha horizontal, logo abaixo.
///
/// Itens lado a lado sem espaçamento: cada um desenha metade da linha.
class PartnerNodeDesktopVersion extends StatefulWidget {
  final Partner partner;
  final bool isFirst;
  final bool isLast;

  const PartnerNodeDesktopVersion({
    super.key,
    required this.partner,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  State<PartnerNodeDesktopVersion> createState() =>
      _PartnerNodeDesktopVersionState();
}

class _PartnerNodeDesktopVersionState extends State<PartnerNodeDesktopVersion> {
  bool _hovered = false;

  static const double _stemHeight = 28.0;
  static const double _plateHeight = 104.0;
  static const double _contentMaxWidth = 280.0;

  Widget _segment(bool visible) => Expanded(
        child: Container(
          height: _lineWidth,
          color: visible ? _lineColor : Colors.transparent,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final partner = widget.partner;

    return Semantics(
      link: true,
      label: 'Abrir o site de ${partner.name}',
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openSite(partner.url),
          child: Column(
            children: [
              SizedBox(
                height: _nodeSize,
                child: Row(
                  children: [
                    _segment(!widget.isFirst),
                    _Node(active: _hovered),
                    _segment(!widget.isLast),
                  ],
                ),
              ),
              Container(width: _lineWidth, height: _stemHeight, color: _lineColor),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _LogoPlate(
                        logoPath: partner.logoPath,
                        logoScale: partner.logoScale,
                        height: _plateHeight,
                        lifted: _hovered,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 20),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        partner.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          color: CustomColors.pine_shadow,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        partner.fullName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.meta.copyWith(
                          fontSize: 14,
                          height: 1.45,
                          color: CustomColors.pine_shadow.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SiteLink(url: partner.url, underlined: _hovered),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Nó da rede (mobile): linha vertical à esquerda, conteúdo à direita.
///
/// Itens empilhados sem espaçamento, pelo mesmo motivo do desktop.
class PartnerNodeMobileVersion extends StatelessWidget {
  final Partner partner;
  final bool isFirst;
  final bool isLast;

  const PartnerNodeMobileVersion({
    super.key,
    required this.partner,
    this.isFirst = false,
    this.isLast = false,
  });

  static const double _railWidth = 24.0;
  static const double _plateHeight = 76.0;
  static const double _verticalPadding = 14.0;

  @override
  Widget build(BuildContext context) {
    // Alinha o centro do nó ao centro do logo.
    const double nodeTop =
        _verticalPadding + _plateHeight / 2 - _nodeSize / 2;

    Widget segment(bool visible, {double? height}) {
      final line = Container(
        width: _lineWidth,
        color: visible ? _lineColor : Colors.transparent,
      );
      return height != null
          ? SizedBox(height: height, child: line)
          : Expanded(child: line);
    }

    return Semantics(
      link: true,
      label: 'Abrir o site de ${partner.name}',
      excludeSemantics: true,
      child: InkWell(
        onTap: () => _openSite(partner.url),
        borderRadius: BorderRadius.circular(16),
        splashColor: CustomColors.pine_shadow.withOpacity(0.08),
        highlightColor: CustomColors.pine_shadow.withOpacity(0.05),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: _railWidth,
                child: Column(
                  children: [
                    segment(!isFirst, height: nodeTop),
                    const _Node(active: false),
                    segment(!isLast),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      0, _verticalPadding, 4, _verticalPadding + 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 220),
                        child: _LogoPlate(
                          logoPath: partner.logoPath,
                          logoScale: partner.logoScale,
                          height: _plateHeight,
                          lifted: false,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        partner.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'RobotoSlab',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          color: CustomColors.pine_shadow,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        partner.fullName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.meta.copyWith(
                          height: 1.45,
                          color: CustomColors.pine_shadow.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _SiteLink(url: partner.url, underlined: false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Círculo vazado do logo da marca; preenche de cobre quando ativo.
class _Node extends StatelessWidget {
  final bool active;

  const _Node({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _hoverDuration,
      width: _nodeSize,
      height: _nodeSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? CustomColors.copper_spice : CustomColors.vanilla_haze,
        border: Border.all(
          color: active ? CustomColors.copper_spice : CustomColors.pine_shadow,
          width: 3,
        ),
      ),
    );
  }
}

/// Placa branca em pílula para o logo (marcas feitas para fundo claro).
class _LogoPlate extends StatelessWidget {
  final String logoPath;
  final double logoScale;
  final double height;
  final bool lifted;
  final EdgeInsetsGeometry padding;

  const _LogoPlate({
    required this.logoPath,
    required this.logoScale,
    required this.height,
    required this.lifted,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _hoverDuration,
      curve: Curves.easeOut,
      height: height,
      width: double.infinity,
      padding: padding,
      transform: Matrix4.translationValues(0, lifted ? -4 : 0, 0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(
          color: lifted ? CustomColors.copper_spice : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(lifted ? 0.18 : 0.08),
            blurRadius: lifted ? 22 : 12,
            offset: Offset(0, lifted ? 10 : 4),
          ),
        ],
      ),
      child: Transform.scale(
        scale: logoScale,
        child: Image.asset(logoPath, fit: BoxFit.contain),
      ),
    );
  }
}

/// Domínio do site com o ícone de link externo ("utfpr.edu.br ↗").
class _SiteLink extends StatelessWidget {
  final String url;
  final bool underlined;

  const _SiteLink({required this.url, required this.underlined});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            _domain(url),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: CustomColors.pine_shadow,
              decoration:
                  underlined ? TextDecoration.underline : TextDecoration.none,
              decorationColor: CustomColors.pine_shadow,
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Icon(
          Icons.north_east_rounded,
          size: 16,
          color: CustomColors.pine_shadow,
        ),
      ],
    );
  }
}
