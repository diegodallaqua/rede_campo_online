import 'package:flutter/material.dart';
import '../ui/theme/custom_colors.dart';


Future<void> openCalendar({
  DateTime? initialDate,
  required ValueChanged<DateTime> onDateSelected,
  DateTime? firstDate,
  DateTime? lastDate,
  required BuildContext context,
}) async {
  final today = DateTime.now();

  final pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate ?? today,
    firstDate: firstDate ?? today.subtract(const Duration(days: 365 * 2)),
    lastDate: lastDate ?? today.add(const Duration(days: 365 * 2)),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: CustomColors.pine_shadow,
            onSurface: CustomColors.pine_shadow,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: CustomColors.midnight_slate,
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate == null) return;
  onDateSelected(pickedDate);
}