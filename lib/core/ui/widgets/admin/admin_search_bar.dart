import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';

/// [CustomSearchBar] com a paleta das listagens do painel.
class AdminSearchBar extends StatelessWidget {
  const AdminSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.hintText = 'Pesquisar',
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return CustomSearchBar(
      controller: controller,
      onSubmitted: onSubmitted,
      hintText: hintText,
      backgroundColor: Colors.white,
      borderColor: CustomColors.concrete_mist,
      textColor: CustomColors.midnight_slate,
      hintColor: CustomColors.midnight_slate.withOpacity(0.7),
      iconColor: CustomColors.copper_spice,
    );
  }
}
