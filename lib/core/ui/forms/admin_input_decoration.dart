import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

const _errorColor = Color(0xFFCF1322);
const _borderColor = Color(0xFFE2E2DC);

OutlineInputBorder _border(Color color, [double width = 1.0]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: width),
  );
}

/// Decoração padrão dos campos de formulário do painel administrativo
/// (fundo claro, borda arredondada, ícone à esquerda e destaque cobre no
/// foco). Centraliza o visual que antes era replicado em cada campo.
///
/// [highlightError] tinge a borda do estado habilitado quando o erro é
/// exibido fora da decoração (campos que renderizam a mensagem por conta
/// própria, como dropdowns com texto de erro abaixo).
InputDecoration adminInputDecoration({
  required String label,
  required IconData icon,
  String? errorText,
  bool highlightError = false,
  double verticalPadding = 14,
}) {
  return InputDecoration(
    labelText: label,
    errorText: errorText,
    labelStyle: TextStyle(
      color: CustomColors.midnight_slate.withOpacity(0.45),
      fontSize: 14,
    ),
    floatingLabelStyle: const TextStyle(
      color: CustomColors.copper_spice,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    prefixIcon: Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Icon(
        icon,
        color: CustomColors.midnight_slate.withOpacity(0.45),
        size: 18,
      ),
    ),
    filled: true,
    fillColor: CustomColors.vanilla_haze.withOpacity(0.05),
    contentPadding:
        EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
    border: _border(_borderColor),
    enabledBorder: _border(
      highlightError ? _errorColor : _borderColor,
      highlightError ? 1.5 : 1.0,
    ),
    focusedBorder: _border(CustomColors.copper_spice, 1.5),
    errorBorder: _border(_errorColor),
    focusedErrorBorder: _border(_errorColor, 1.5),
  );
}
