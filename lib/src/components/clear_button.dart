import 'package:flutter/material.dart';

class ClearButton<T> extends StatelessWidget {
  final Function(T?) onChanged;

  const ClearButton({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onChanged(null),
      icon: Icon(Icons.clear),
    );
  }
}
