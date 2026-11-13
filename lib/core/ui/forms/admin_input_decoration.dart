import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

const _errorColor = CustomColors.danger_red;
const _borderColor = CustomColors.soft_border;

OutlineInputBorder _border(Color color, [double width = 1.0]) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: width),
  );
}

/// Decoração padrão dos campos do painel.
///
/// [highlightError] tinge a borda quando o erro é exibido fora da decoração
/// (ex.: dropdowns com texto de erro próprio).
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
    labelStyle: const TextStyle(
      color: CustomColors.muted_text,
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
        color: CustomColors.muted_text,
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
