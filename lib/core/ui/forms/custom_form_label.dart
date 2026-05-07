import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';

class CustomFormLabel extends StatelessWidget {
  CustomFormLabel({required this.title, this.textAlign, Key? key}) : super(key: key);

  String title;
  TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: const TextStyle(
        color: CustomColors.pine_shadow,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
