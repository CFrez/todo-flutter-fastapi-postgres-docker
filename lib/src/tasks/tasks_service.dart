import 'package:family/src/tasks/providers/tasks_list_provider.dart';
import 'package:family/src/tasks/task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family/main.dart';
import 'package:family/src/utils/api_service.dart';

const tasksBaseUrl = 'tasks';

class TasksService extends ApiService {
  List<Task> tasks = [];

  Future<List<Task>> list() async {
    final data = await getList(tasksBaseUrl);
    tasks = data.map((task) => Task.fromJson(task)).toList();
    return tasks;
  }

  Future<Task> create(Task task) async {
    final data = await post(tasksBaseUrl, task.toJson());
    // add task vs refetch?
    final groceryItem = Task.fromJson(data);
    getIt<TasksListProvider>().fetchTasks();
    return groceryItem;
  }

  Future<Task> read(String taskId) async {
    final data = await get('$tasksBaseUrl/$taskId');
    return Task.fromJson(data);
  }

  Future<Task> update(Task task) async {
    final data = await patch('$tasksBaseUrl/${task.id}', task.toJson());
    final groceryItem = Task.fromJson(data);
    getIt<TasksListProvider>().fetchTasks();
    return groceryItem;
  }

  Future<void> deleteTask(Task task) async {
    await super.delete('$tasksBaseUrl/${task.id}');
    getIt<TasksListProvider>().fetchTasks();
  }
}

TasksService _export() {
  final service = Provider((ref) => TasksService());
  final container = ProviderContainer();
  return container.read(service);
}

final tasksService = _export();
