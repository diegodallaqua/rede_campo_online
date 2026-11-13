import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/theme/custom_colors.dart';

/// Fecha a tela do painel; sem histórico, vai para [fallbackRoute].
void closeAdminPage(
  BuildContext context,
  String fallbackRoute, [
  Object? result,
]) {
  if (context.canPop()) {
    context.pop(result);
  } else {
    context.go(fallbackRoute);
  }
}

/// Abre um formulário do painel. Se fechar com mensagem, mostra o aviso e
/// retorna true para recarregar a origem.
Future<bool> openAdminForm(
  BuildContext context,
  String route, {
  Object? extra,
}) async {
  final message = await context.push<String>(route, extra: extra);
  if (message == null || !context.mounted) return false;
  showAdminSuccess(context, message);
  return true;
}

/// Aviso de sucesso do painel.
void showAdminSuccess(BuildContext context, String message) {
  final isDesktop = MediaQuery.sizeOf(context).width > 768;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: isDesktop ? 420 : null,
        backgroundColor: CustomColors.pine_shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: CustomColors.fresh_sprout,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: CustomColors.vanilla_haze,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
