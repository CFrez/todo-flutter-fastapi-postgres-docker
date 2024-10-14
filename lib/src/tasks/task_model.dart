import 'package:family/src/utils/base_model.dart';

class Task extends BaseModel {
  String title = '';
  String? description;
  DateTime? dueDate;
  bool isCompleted = false;
  String? parentId;

  List<Task> subTasks = [];

  Task() {
    // Empty constructor for initialization
  }

  Task.fromJson(Map<String, dynamic> json) {
    super.fromBaseJson(json);
    title = json['title'];
    description = json['description'];
    dueDate = formatFromDateTime(json['due_date']);
    isCompleted = json['is_completed'];
    parentId = json['parent_id'];
    subTasks = json['sub_tasks'] != null
        ? json['sub_tasks'].map<Task>((task) => Task.fromJson(task)).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toBaseJson(),
      'title': title,
      'description': description,
      'due_date': formatToDate(dueDate),
      'is_completed': isCompleted,
      'parent_id': parentId,
    };
  }
}
