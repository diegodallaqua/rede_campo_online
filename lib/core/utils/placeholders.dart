import 'package:flutter/material.dart';

import '../ui/theme/custom_colors.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.pine_shadow.withOpacity(0.25),
      child: const Center(
        child: Icon(
          Icons.newspaper_outlined,
          size: 32,
          color: CustomColors.pine_shadow,
        ),
      ),
    );
  }
}

class CoverPlaceholder extends StatelessWidget {
  const CoverPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5A623),
      child: const Center(
        child: Icon(Icons.book_outlined, size: 48, color: Colors.white54),
      ),
    );
  }
}

class AvatarPlaceholder extends StatelessWidget {
  final String? name;
  final Color? backgroundColor;

  const AvatarPlaceholder({super.key, this.name, this.backgroundColor});

  String get _initial {
    final trimmed = name?.trim() ?? '';
    return trimmed.isNotEmpty ? trimmed[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor?.withOpacity(0.25) ??
          CustomColors.copper_spice.withOpacity(0.25),
      child: Center(
        child: Text(
          _initial,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: backgroundColor ?? CustomColors.copper_spice,
          ),
        ),
      ),
    );
  }
}
