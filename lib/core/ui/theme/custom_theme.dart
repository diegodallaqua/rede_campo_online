import 'package:flutter/material.dart';

import 'custom_colors.dart';

/// Tema global do app. Sem ele o Material 3 usa o esquema roxo padrão, que
/// tinge botões elevados, cursor, seleção de texto e indicadores de progresso.
abstract class CustomTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: CustomColors.copper_spice,
      onPrimary: Colors.white,
      secondary: CustomColors.pine_shadow,
      onSecondary: CustomColors.vanilla_haze,
      surface: Colors.white,
      onSurface: CustomColors.midnight_slate,
      background: CustomColors.vanilla_haze,
      onBackground: CustomColors.midnight_slate,
      error: CustomColors.danger_red,
      onError: Colors.white,
      // Remove a sobreposição de cor que o Material 3 aplica a superfícies
      // elevadas (botões, cards, diálogos, menus).
      surfaceTint: Colors.transparent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: CustomColors.vanilla_haze,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: CustomColors.copper_spice,
        selectionColor: CustomColors.copper_spice.withOpacity(0.25),
        selectionHandleColor: CustomColors.copper_spice,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: CustomColors.copper_spice,
      ),
      tooltipTheme: const TooltipThemeData(
        decoration: BoxDecoration(
          color: CustomColors.midnight_slate,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        textStyle: TextStyle(fontSize: 13, color: CustomColors.vanilla_haze),
      ),
    );
  }
}
