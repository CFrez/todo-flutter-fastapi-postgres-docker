import 'package:flutter/material.dart';

import 'package:todo/src/tasks/task_model.dart';
import 'package:todo/src/tasks/tasks_service.dart';

abstract class TasksListProvider extends ChangeNotifier {
  bool isLoading = true;
  List<Task> _tasks = [];

  // Getters
  List<Task> get tasks;

  // Operations
  Future<void> fetchTasks();
}

class TasksListProviderImpl extends TasksListProvider {
  TasksListProviderImpl() {
    _init();
  }

  Future<void> _init() async {
    await fetchTasks();
  }

  @override
  List<Task> get tasks => _tasks;

  @override
  Future<void> fetchTasks() async {
    isLoading = true;
    _tasks = [];
    final tasks = await tasksService.list();
    _tasks = tasks;
    isLoading = false;
    notifyListeners();
  }
}
