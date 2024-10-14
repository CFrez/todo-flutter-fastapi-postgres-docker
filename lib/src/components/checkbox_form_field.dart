import 'package:flutter/material.dart';

class CheckboxFormField extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final String labelText;

  const CheckboxFormField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      horizontalTitleGap: 0,
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(labelText),
        value: value,
        onChanged: (value) {
          value != null && onChanged(value);
        },
        controlAffinity: ListTileControlAffinity.leading,
        // secondary: Icon(icon),
      ),
    );
  }
}
