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
    tasks = data.map((parent) => Task.fromJson(parent)).toList();
    return tasks;
  }

  Future<Task> create(Task parent) async {
    final data = await post(tasksBaseUrl, parent.toJson());
    // add parent vs refetch?
    final groceryItem = Task.fromJson(data);
    getIt<TasksListProvider>().fetchTasks();
    return groceryItem;
  }

  Future<Task> read(String parentId) async {
    final data = await get('$tasksBaseUrl/$parentId');
    return Task.fromJson(data);
  }

  Future<Task> update(Task parent) async {
    final data = await patch('$tasksBaseUrl/${parent.id}', parent.toJson());
    final groceryItem = Task.fromJson(data);
    getIt<TasksListProvider>().fetchTasks();
    return groceryItem;
  }

  Future<void> deleteTask(Task parent) async {
    await super.delete('$tasksBaseUrl/${parent.id}');
    getIt<TasksListProvider>().fetchTasks();
  }
}

TasksService _export() {
  final service = Provider((ref) => TasksService());
  final container = ProviderContainer();
  return container.read(service);
}

final tasksService = _export();
