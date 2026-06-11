import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';

/// Barra de paginação numerada com setas de navegação, usada nas listagens
/// desktop do painel administrativo. A seta de avanço só aparece quando se
/// sabe que a próxima página existe.
class PaginationBar extends StatelessWidget {
  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.hasNextPage,
    required this.enabled,
    required this.onPageSelected,
  });

  final int currentPage;
  final int pageCount;
  final bool hasNextPage;
  final bool enabled;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _arrow(
            icon: Icons.chevron_left_rounded,
            enabled: enabled && currentPage > 1,
            onTap: () => onPageSelected(currentPage - 1),
          ),
          ...List.generate(pageCount, (index) {
            final page = index + 1;
            return _PageNumberButton(
              page: page,
              isActive: page == currentPage,
              enabled: enabled,
              onTap: () => onPageSelected(page),
            );
          }),
          if (hasNextPage)
            _arrow(
              icon: Icons.chevron_right_rounded,
              enabled: enabled,
              onTap: () => onPageSelected(currentPage + 1),
            ),
        ],
      ),
    );
  }

  Widget _arrow({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return ArrowButton(
      icon: icon,
      enabled: enabled,
      onTap: onTap,
      iconColor: CustomColors.midnight_slate,
      disabledIconColor: CustomColors.concrete_mist,
      backgroundColor: Colors.white,
      iconSize: 18,
      borderRadius: 12,
      border: Border.all(color: CustomColors.concrete_mist),
      fixedSize: 36,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      useRipple: false,
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  const _PageNumberButton({
    required this.page,
    required this.isActive,
    required this.enabled,
    required this.onTap,
  });

  final int page;
  final bool isActive;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: enabled && !isActive ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? CustomColors.copper_spice : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? CustomColors.copper_spice
                  : CustomColors.concrete_mist,
            ),
          ),
          child: Center(
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                color: isActive
                    ? Colors.white
                    : enabled
                        ? CustomColors.midnight_slate
                        : CustomColors.concrete_mist,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
