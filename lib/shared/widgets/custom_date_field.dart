import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vintiora/shared/widgets/custom_text_field.dart';

class CustomDateField extends StatelessWidget {
  final String labelText;
  final DateTime selectedDate;
  final Function(DateTime?) onDateChanged;

  const CustomDateField({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      labelText: labelText,
      suffixIcon: const Icon(Icons.calendar_today),
      readOnly: true,
      controller: TextEditingController(
        text: DateFormat('MMM dd, yyyy').format(selectedDate),
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );

        if (picked != null) {
          onDateChanged(picked);
        }
      },
    );
  }
}
