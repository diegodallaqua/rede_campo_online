import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';

class BodyContainer extends StatelessWidget {
  const BodyContainer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: CustomColors.vanilla_haze,
        constraints: const BoxConstraints(
          maxWidth: 1300,
        ),
        child: child,
      ),
    );
  }
}