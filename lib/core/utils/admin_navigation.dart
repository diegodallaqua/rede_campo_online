import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/theme/custom_colors.dart';

/// Fecha a tela atual do painel. Sem histórico (aberta por link direto ou
/// pela barra lateral), vai para [fallbackRoute].
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

/// Abre um formulário do painel. Quando o formulário fecha com uma mensagem
/// (publicado, salvo ou apagado), mostra o aviso de sucesso e retorna true
/// para que a tela de origem recarregue seus dados.
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

/// Aviso curto de sucesso usado pelo painel administrativo.
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
