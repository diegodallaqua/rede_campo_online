import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';
import '../theme/custom_text_styles.dart';

/// Cabeçalho das páginas internas (Projetos, Publicações, Eventos, Notícias e
/// A Rede Campo): chamada curta, título na fonte da marca e texto de
/// apresentação.
///
/// [title] herda o estilo de título de página em [CustomColors.copper_spice];
/// trechos com outra cor podem ser passados como filhos do [TextSpan].
class PageHeaderSectionDesktopVersion extends StatelessWidget {
  final String preTitle;
  final InlineSpan title;
  final String description;

  const PageHeaderSectionDesktopVersion({
    super.key,
    required this.preTitle,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 56, 48, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          preTitle,
                          style: CustomTextStyles.bodyDesktop.copyWith(
                            color: CustomColors.pine_shadow,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: CustomTextStyles.pageTitleDesktop.copyWith(
                              color: CustomColors.copper_spice,
                            ),
                            children: [title],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                  Expanded(
                    flex: 7,
                    child: Text(
                      description,
                      style: CustomTextStyles.bodyDesktop.copyWith(
                        color: CustomColors.pine_shadow,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Divider(
                height: 1,
                thickness: 1,
                color: CustomColors.pine_shadow.withOpacity(0.18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageHeaderSectionMobileVersion extends StatelessWidget {
  final String preTitle;
  final InlineSpan title;
  final String description;

  const PageHeaderSectionMobileVersion({
    super.key,
    required this.preTitle,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            preTitle,
            style: CustomTextStyles.bodyMobile.copyWith(
              color: CustomColors.pine_shadow,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: CustomTextStyles.pageTitleMobile.copyWith(
                color: CustomColors.copper_spice,
              ),
              children: [title],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: CustomTextStyles.bodyMobile.copyWith(
              color: CustomColors.pine_shadow,
            ),
          ),
        ],
      ),
    );
  }
}
