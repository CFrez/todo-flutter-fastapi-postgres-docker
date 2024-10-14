import 'package:flutter/material.dart';

class CheckboxButton extends StatelessWidget {
  final bool isChecked;
  final Function onUpdate;

  const CheckboxButton(
      {super.key, required this.isChecked, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          onUpdate();
        },
        icon: Icon(
          isChecked ? Icons.check_box : Icons.check_box_outline_blank,
        ));
  }
}
