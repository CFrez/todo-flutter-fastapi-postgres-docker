import 'package:flutter/material.dart';

import 'package:todo/src/tasks/task_model.dart';
import 'package:todo/src/tasks/tasks_service.dart';

abstract class TaskDetailsProvider extends ChangeNotifier {
  Task _task = Task();
  bool _isProcessing = false;
  final _form = GlobalKey<FormState>();

  // Getters
  Task get task;
  bool get isProcessing;
  GlobalKey<FormState> get form;
  List<Task> get subTasks;

  // Operations
  void clearTask();
  void setTask(Task task);
  Future<Task?> saveTask();
  Future<void> deleteTask(Task task);
  void refreshTask();

  // Validation
  String? validateTitle(String? value);

  // Setters
  void setTitle(String title);
  void setDescription(String description);
  void setDueDate(DateTime? dueDate);
  void setIsCompleted(bool? completed);
}

class TaskDetailsProviderImpl extends TaskDetailsProvider {
  void handleUpdate() {
    notifyListeners();
  }

  @override
  Task get task => _task;

  @override
  bool get isProcessing => _isProcessing;

  @override
  GlobalKey<FormState> get form => _form;

  @override
  List<Task> get subTasks => _task.subTasks;

  @override
  void clearTask() {
    _task = Task();
    handleUpdate();
  }

  @override
  void setTask(Task task) {
    _task = task;
    handleUpdate();
  }

  @override
  void refreshTask() async {
    if (_task.id == null) {
      return;
    }
    final task = await tasksService.read(_task.id!);
    _task = task;

    handleUpdate();
  }

  @override
  Future<Task?> saveTask() async {
    if (!_form.currentState!.validate()) {
      handleUpdate();
      return null;
    }
    _isProcessing = true;
    final isNew = _task.id == null;
    final savedTask = isNew
        ? await tasksService.create(_task)
        : await tasksService.update(_task);
    _isProcessing = false;
    // ToastService.success('${savedTask.title} ${isNew ? 'added' : 'updated'}');
    return savedTask;
  }

  @override
  Future<void> deleteTask(Task task) async {
    _isProcessing = true;
    await tasksService.deleteTask(task);
    _isProcessing = false;
    // ToastService.success('${task.title} deleted');
    handleUpdate();
  }

  @override
  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Task Title is Required';
    }
    return null;
  }

  @override
  void setTitle(String title) {
    _task.title = title;
    handleUpdate();
  }

  @override
  void setDescription(String description) {
    _task.description = description;
    handleUpdate();
  }

  @override
  void setDueDate(DateTime? dueDate) {
    _task.dueDate = dueDate;
    handleUpdate();
  }

  @override
  setIsCompleted(completed) {
    _task.isCompleted = completed ?? _task.isCompleted;
    handleUpdate();
  }
}
