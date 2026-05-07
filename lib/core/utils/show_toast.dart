import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../ui/theme/custom_colors.dart';


void showToast({
  required FToast fToast,
  required String message,
  bool isError = false,
}) {
  final toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: isError ? CustomColors.copper_spice : CustomColors.midnight_slate,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isError ? Icons.close : Icons.check,
          color: Colors.white,
        ),
        const SizedBox(width: 12.0),
        Text(
          message,
          style: const TextStyle(
            color: CustomColors.midnight_slate,
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 3),
  );
}