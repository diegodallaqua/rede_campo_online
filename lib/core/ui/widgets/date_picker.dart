import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/custom_colors.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onTap,
    this.errorText,
    this.placeholder = 'Data de publicação',
  });

  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String? errorText;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final label = selectedDate != null
        ? DateFormat('dd/MM/yyyy', 'pt_BR').format(selectedDate!)
        : placeholder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: CustomColors.vanilla_haze.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasError
                    ? CustomColors.danger_red
                    : CustomColors.soft_border,
                width: hasError ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: hasError
                      ? CustomColors.danger_red
                      : CustomColors.midnight_slate.withOpacity(0.38),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedDate != null
                        ? CustomColors.midnight_slate
                        : CustomColors.midnight_slate.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: CustomColors.danger_red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

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
