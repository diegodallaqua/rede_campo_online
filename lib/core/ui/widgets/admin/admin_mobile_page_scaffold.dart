import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/gradient_header.dart';

/// Estrutura das telas mobile do painel administrativo: fundo em gradiente,
/// [GradientHeader] com título/subtítulo e folha clara arredondada onde o
/// conteúdo é exibido.
class AdminMobilePageScaffold extends StatelessWidget {
  const AdminMobilePageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.child,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColors.copper_spice, CustomColors.midnight_slate],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            GradientHeader(
              title: title,
              subtitle: subtitle,
              onBack: onBack,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: CustomColors.salt_flower,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
