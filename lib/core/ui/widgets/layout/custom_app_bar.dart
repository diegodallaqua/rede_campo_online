import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';

import '../../theme/custom_colors.dart';
import 'nav_items.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  static const double height = 72;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 768;

    return AppBar(
      toolbarHeight: height,
      backgroundColor: CustomColors.vanilla_haze,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      shape: const Border(
        bottom: BorderSide(color: CustomColors.soft_border),
      ),
      title: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 16),
            child: Row(
              children: [
                const _Logo(),
                if (isDesktop) ...[
                  const SizedBox(width: 32),
                  const _DesktopNavLinks(),
                  const Spacer(),
                  _LoginButton(showLabel: width >= 1200),
                ] else ...[
                  const Spacer(),
                  IconButton(
                    tooltip: 'Menu',
                    icon: const Icon(
                      Icons.menu,
                      color: CustomColors.midnight_slate,
                      size: 28,
                    ),
                    onPressed: onMenuTap,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    // O arquivo do logo tem margem transparente; o recorte centralizado em
    // 200×56 deixa só o emblema e o nome visíveis.
    return Semantics(
      label: 'Rede Campo, ir para o início',
      button: true,
      child: InkWell(
        onTap: () => context.go(AppRoutes.home),
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/logo_horizontal.png',
          width: 200,
          height: 56,
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}

class _DesktopNavLinks extends StatelessWidget {
  const _DesktopNavLinks();

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: navItems
          .map((item) => _NavLink(
                item: item,
                isActive: item.isActive(currentPath),
              ))
          .toList(),
    );
  }
}

/// Aba da barra superior: sublinhado cobre de 3px quando ativa e cinza ao
/// passar o mouse, encostado na linha inferior da barra.
class _NavLink extends StatefulWidget {
  final NavItem item;
  final bool isActive;

  const _NavLink({required this.item, required this.isActive});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;
    final Color textColor = isActive
        ? CustomColors.copper_spice
        : _hovered
            ? CustomColors.pine_shadow
            : CustomColors.midnight_slate;
    final Color underlineColor = isActive
        ? CustomColors.copper_spice
        : _hovered
            ? CustomColors.concrete_mist
            : Colors.transparent;

    return InkWell(
      onTap: () => context.go(widget.item.route),
      onHover: (value) => setState(() => _hovered = value),
      hoverColor: Colors.transparent,
      splashColor: CustomColors.copper_spice.withOpacity(0.08),
      highlightColor: Colors.transparent,
      child: SizedBox(
        height: CustomAppBar.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                widget.item.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: textColor,
                  letterSpacing: 0.2,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  height: 3,
                  decoration: BoxDecoration(
                    color: underlineColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.showLabel});

  /// Em telas entre 1024 e 1200px só o ícone cabe ao lado das abas.
  final bool showLabel;

  static const String _label = 'Área do pesquisador';

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      foregroundColor: CustomColors.pine_shadow,
      side: const BorderSide(color: CustomColors.pine_shadow, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      minimumSize: const Size(40, 40),
      padding: EdgeInsets.symmetric(horizontal: showLabel ? 16 : 0),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
    const icon = Icon(Icons.person_outline_rounded, size: 20);

    void onPressed() => context.go(AppRoutes.login);

    if (!showLabel) {
      return Tooltip(
        message: _label,
        child: OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: icon,
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: style,
      icon: icon,
      label: const Text(_label),
    );
  }
}
