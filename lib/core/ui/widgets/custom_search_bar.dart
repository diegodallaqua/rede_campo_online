import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CustomColors.concrete_mist),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 14,
                color: CustomColors.concrete_mist,
              ),
              decoration: const InputDecoration(
                hintText: 'Pesquisar',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: CustomColors.concrete_mist,
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                isDense: true,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: CustomColors.concrete_mist,
              size: 20,
            ),
            onPressed: () => onSubmitted(controller.text),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(),
          ),
          Container(
            width: 1,
            height: 24,
            color: CustomColors.concrete_mist,
          ),
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: CustomColors.concrete_mist,
              size: 20,
            ),
            onPressed: () {
              // TODO: abrir filtros avançados
            },
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
