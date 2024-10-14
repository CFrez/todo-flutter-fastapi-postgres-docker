import 'package:flutter/material.dart';

import 'package:family/src/components/empty_list_indicator.dart';
import 'package:family/src/tasks/components/task_card.dart';
import 'package:family/main.dart';
import 'package:family/src/tasks/providers/tasks_list_provider.dart';

class TasksList extends StatefulWidget {
  final Function handleAddTask;
  const TasksList({super.key, required this.handleAddTask});

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final listProvider = getIt<TasksListProvider>();

  @override
  void initState() {
    super.initState();

    listProvider.addListener(() {
      setStateIfMounted(() {});
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> _refreshData() async {
    await listProvider.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = listProvider.tasks;

    if (listProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (tasks.isEmpty) {
      return Center(
        child: EmptyListIndicator(
          buttonText: 'Add Task',
          onButtonPressed: () {
            widget.handleAddTask();
          },
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _refreshData(),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks.elementAt(index);
          return TaskCard(
            task: task,
          );
        },
      ),
    );
  }
}
