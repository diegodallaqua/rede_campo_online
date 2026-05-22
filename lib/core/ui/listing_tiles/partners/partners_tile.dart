import 'package:flutter/material.dart';
import '../../theme/custom_colors.dart';

class PartnerTile extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const PartnerTile({
    super.key,
    required this.imagePath,
    this.onTap,
    this.width = 160,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: CustomColors.honey_cream,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CustomColors.midnight_slate.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );

    if (onTap == null) return tile;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: tile,
      ),
    );
  }
}
