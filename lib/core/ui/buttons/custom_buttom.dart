import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.width,
    required this.color,
    required this.text,
    required this.function,
    this.textColor,
    this.borderRadius
  });

  final double? width;
  final Color color;
  final Color? textColor;
  final String text;
  final Function()? function;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 24),
            ),
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            elevation: 8,
            shadowColor: CustomColors.midnight_slate
        ),

        onPressed: function,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 17,
              color: textColor ?? CustomColors.fresh_sprout
          ),
        ),
      ),
    );
  }
}
