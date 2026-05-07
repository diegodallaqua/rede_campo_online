import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';

class ListDivider extends StatelessWidget {
  const ListDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: CustomColors.midnight_slate.withOpacity(0.4),
      thickness: 1,
      height: 0,
    );
  }
}
