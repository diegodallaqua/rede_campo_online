import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class ListLoadingState extends StatelessWidget {
  final Color color;
  final double height;

  const ListLoadingState({
    super.key,
    this.color = CustomColors.copper_spice,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: 2.5,
        ),
      ),
    );
  }
}
