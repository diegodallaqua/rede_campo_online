import 'package:flutter/material.dart';

import '../../../utils/admin_navigation.dart';
import '../confirmation_dialog.dart';

/// Guarda o texto inicial dos campos de um formulário do painel e pede
/// confirmação antes de sair quando algo foi digitado.
///
/// Crie depois que os controllers receberem os valores iniciais.
class AdminLeaveGuard {
  AdminLeaveGuard(List<TextEditingController> controllers)
      : _controllers = controllers,
        _initialTexts = controllers.map((c) => c.text).toList();

  final List<TextEditingController> _controllers;
  List<String> _initialTexts;

  /// Toma o texto atual como ponto de partida. Use quando o próprio
  /// formulário preenche campos depois de aberto (dados que chegam
  /// assíncronos), para não confundir isso com edição do usuário.
  void resetBaseline() {
    _initialTexts = _controllers.map((c) => c.text).toList();
  }

  bool get hasChanges {
    for (var i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text != _initialTexts[i]) return true;
    }
    return false;
  }

  /// Fecha o formulário; com texto alterado, só fecha se o usuário confirmar.
  Future<void> leave(BuildContext context, String fallbackRoute) async {
    if (hasChanges) {
      final discard = await ConfirmationDialog.show(
        context: context,
        title: 'Descartar alterações?',
        message: 'O que você digitou neste formulário será perdido.',
        cancelLabel: 'Continuar editando',
        confirmLabel: 'Descartar',
      );
      if (discard != true || !context.mounted) return;
    }
    closeAdminPage(context, fallbackRoute);
  }
}
