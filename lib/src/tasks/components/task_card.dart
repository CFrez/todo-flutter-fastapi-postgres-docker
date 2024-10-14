import 'package:flutter/material.dart';

import 'package:family/main.dart';
import 'package:family/src/tasks/screens/task_detail_screen.dart';
import 'package:family/src/tasks/task_model.dart';
import 'package:family/src/tasks/providers/task_details_provider.dart';
import 'package:family/src/tasks/tasks_service.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          tasksService.deleteTask(task);
        }
      },
      background: Container(
        decoration: BoxDecoration(color: Colors.red),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 18),
              onPressed: () {
                getIt<TaskDetailsProvider>().setTask(task);
                Navigator.of(context).pushNamed(TaskDetailScreen.routeName);
              },
            ),
            Expanded(
              child: Text(task.name),
            ),
          ],
        ),
      ),
    );
  }
}
