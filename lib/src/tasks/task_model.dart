import 'package:family/src/utils/base_model.dart';

class Task extends BaseModel {
  String name = '';
  String description = '';
  DateTime? dueDate;
  bool isCompleted = false;

  Task() {
    // Empty constructor for initialization
  }

  Task.fromJson(Map<String, dynamic> json) {
    super.fromBaseJson(json);
    name = json['name'];
    description = json['description'];
    dueDate = formatFromDateTime(json['due_date']);
    isCompleted = json['is_completed'];
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toBaseJson(),
      'name': name,
      'description': description,
      'due_date': formatToDate(dueDate),
      'is_completed': isCompleted,
    };
  }
}
