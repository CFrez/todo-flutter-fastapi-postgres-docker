import 'package:flutter/material.dart';

import 'package:family/src/tasks/task_model.dart';
import 'package:family/src/tasks/tasks_service.dart';

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
  void setDescription(String? description);
  void setDueDate(DateTime? dueDate);
  void setIsCompleted(bool? completed);
  void setParentId(String? parentId);
}

class TaskDetailsProviderImpl extends TaskDetailsProvider {
  void handleUpdate() {
    notifyListeners();
  }

  @override
  get task => _task;

  @override
  get isProcessing => _isProcessing;

  @override
  get form => _form;

  @override
  get subTasks => _task.subTasks;

  @override
  clearTask() {
    _task = Task();
    handleUpdate();
  }

  @override
  setTask(Task task) {
    _task = task;
    handleUpdate();
  }

  @override
  refreshTask() async {
    if (_task.id == null) {
      return;
    }
    final task = await tasksService.read(_task.id!);
    _task = task;

    handleUpdate();
  }

  @override
  saveTask() async {
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
  deleteTask(task) async {
    _isProcessing = true;
    await tasksService.deleteTask(task);
    _isProcessing = false;
    // ToastService.success('${task.title} deleted');
    handleUpdate();
  }

  @override
  validateTitle(value) {
    if (value == null || value.isEmpty) {
      return 'Task Title is Required';
    }
    return null;
  }

  @override
  setTitle(title) {
    _task.title = title;
    handleUpdate();
  }

  @override
  setDescription(description) {
    _task.description = description;
    handleUpdate();
  }

  @override
  setDueDate(dueDate) {
    _task.dueDate = dueDate;
    handleUpdate();
  }

  @override
  setIsCompleted(completed) {
    _task.isCompleted = completed ?? _task.isCompleted;
    handleUpdate();
  }

  @override
  setParentId(parentId) {
    _task.parentId = parentId;
    handleUpdate();
  }
}
