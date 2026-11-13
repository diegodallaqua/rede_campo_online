import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';

/// FAB de criação das listagens do painel (só mobile).
class AdminCreateFab extends StatelessWidget {
  const AdminCreateFab({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  /// O FAB só aparece quando o layout mobile está ativo.
  static bool isVisible(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= 768;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: CustomColors.copper_spice,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.add_rounded, size: 22),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }
}
