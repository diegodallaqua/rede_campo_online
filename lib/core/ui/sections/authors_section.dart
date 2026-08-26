import 'package:flutter/material.dart';

import '../../models/contributor.dart';
import '../theme/custom_colors.dart';
import '../widgets/contributors_carousel.dart';

/// Seção "Autores" das telas de detalhe de publicações (artigos, livros,
/// capítulos e dissertações) - variante desktop, com título alinhado à
/// esquerda seguido de um divisor em degradê.
class AuthorsSectionDesktopVersion extends StatelessWidget {
  final String title;
  final String emptyMessage;
  final List<Contributors> contributors;

  const AuthorsSectionDesktopVersion({
    super.key,
    required this.title,
    required this.emptyMessage,
    required this.contributors,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 24, 48, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.fresh_sprout,
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
                            CustomColors.fresh_sprout.withOpacity(0.4),
                            CustomColors.fresh_sprout.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ContributorsCarousel(
                contributors: contributors,
                emptyMessage: emptyMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Variante mobile da seção "Autores", com título centralizado.
class AuthorsSectionMobileVersion extends StatelessWidget {
  final String title;
  final String emptyMessage;
  final List<Contributors> contributors;

  const AuthorsSectionMobileVersion({
    super.key,
    required this.title,
    required this.emptyMessage,
    required this.contributors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ContributorsCarousel(
            contributors: contributors,
            emptyMessage: emptyMessage,
          ),
        ],
      ),
    );
  }
}
