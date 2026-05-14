import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.vanilla_haze,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 160,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.menu,
            color: CustomColors.midnight_slate,
            size: 28,
          ),
          onPressed: () {
            // TODO: abrir drawer/menu de navegação
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
