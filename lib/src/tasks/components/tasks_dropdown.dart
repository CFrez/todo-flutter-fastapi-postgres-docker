import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:family/main.dart';
import 'package:family/src/components/clear_button.dart';
import 'package:family/src/tasks/providers/tasks_list_provider.dart';
import 'package:family/src/tasks/task_model.dart';

class TasksDropdown extends StatelessWidget {
  final String? initialTaskId;
  final Function(String?) onChanged;
  final String labelText;
  final IconData icon;

  TasksDropdown({
    super.key,
    required this.initialTaskId,
    required this.onChanged,
    this.labelText = 'Task',
    this.icon = Icons.upload,
  });

  final listProvider = getIt<TasksListProvider>();

  @override
  Widget build(BuildContext context) {
    final dropDownItems = listProvider.tasks
        .map((Task task) => DropdownMenuItem<Task>(
              value: task,
              child: Text(task.title, overflow: TextOverflow.ellipsis),
            ))
        .toList();
    return DropdownButtonFormField<Task>(
      isExpanded: true,
      value: listProvider.tasks
          .firstWhereOrNull((task) => task.id == initialTaskId),
      decoration: InputDecoration(
          icon: Icon(icon),
          labelText: labelText,
          suffixIcon: ClearButton(onChanged: onChanged)),
      items: dropDownItems,
      onChanged: (Task? task) {
        task != null && onChanged(task.id!);
      },
    );
  }
}
