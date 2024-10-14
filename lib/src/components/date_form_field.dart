import 'package:family/src/components/clear_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

// This provides an input to handle Date only values that are in the future.
//
// It is required to be wrapped in a Form widget
class FutureDateFormField extends StatelessWidget {
  final DateTime? initialValue;
  final Function(DateTime?) onChanged;
  final FormFieldValidator<String>? validator;
  final String labelText;
  final IconData icon;
  final bool isClearable;

  // TODO: This doesn't show updated date when the date is changed

  const FutureDateFormField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.validator,
    this.labelText = 'Date',
    this.icon = Icons.calendar_today,
    this.isClearable = true,
  });

  String? _formatDate(DateTime? date) {
    return date != null ? DateFormat('MM-dd-yyyy').format(date) : null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: _formatDate(initialValue),
        decoration: InputDecoration(
          icon: Icon(icon),
          labelText: labelText,
          suffixIcon: isClearable ? ClearButton(onChanged: onChanged) : null,
        ),
        readOnly: true, // when true user cannot edit text
        validator: validator,
        onTap: () async {
          final now = DateTime.now();
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: initialValue ?? now,
              firstDate: now,
              lastDate: DateTime(now.year + 10));
          if (pickedDate != null) {
            onChanged(pickedDate);
          }
        });
  }
}
