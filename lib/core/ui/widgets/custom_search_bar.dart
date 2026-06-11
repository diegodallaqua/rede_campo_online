import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final String hintText;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color hintColor;
  final Color iconColor;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.hintText = 'Pesquisar',
    this.backgroundColor = Colors.transparent,
    this.borderColor = CustomColors.concrete_mist,
    this.textColor = CustomColors.concrete_mist,
    this.hintColor = CustomColors.concrete_mist,
    this.iconColor = CustomColors.concrete_mist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: hintColor,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                isDense: true,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: iconColor,
                  size: 20,
                ),
                onPressed: () {
                  controller.clear();
                  onSubmitted('');
                },
                padding: const EdgeInsets.symmetric(horizontal: 8),
                constraints: const BoxConstraints(),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: iconColor,
              size: 20,
            ),
            onPressed: () => onSubmitted(controller.text),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(),
          ),
          Container(
            width: 1,
            height: 24,
            color: borderColor,
          ),
          IconButton(
            icon: Icon(
              Icons.tune_rounded,
              color: iconColor,
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
