import 'package:family/src/tasks/components/tasks_list.dart';
import 'package:flutter/material.dart';

import 'package:family/main.dart';
import 'package:family/src/tasks/providers/task_details_provider.dart';
import 'package:family/src/tasks/providers/tasks_list_provider.dart';
import 'package:family/src/tasks/screens/task_detail_screen.dart';

class TasksListScreen extends StatefulWidget {
  static const routeName = '/';

  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  final listProvider = getIt<TasksListProvider>();

  void _handleAddTask() {
    getIt<TaskDetailsProvider>().clearTask();
    Navigator.of(context).pushNamed(TaskDetailScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _handleAddTask();
        },
        child: const Icon(Icons.add),
      ),
      body: TasksList(handleAddTask: _handleAddTask),
    );
  }
}
