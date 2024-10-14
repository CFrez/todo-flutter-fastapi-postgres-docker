import 'package:intl/intl.dart';

// This BaseModel matches the backend BaseModel 'backend/app/db/models/base.py'.
//
// All of these fields are managed by the backend and should not be modified
// by the frontend. They are shown as optional here because they are not
// required when creating a new object.
//
// TODO: Is it possible for make these fields only allowed to be set within the
// fromBaseJson method?
class BaseModel {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  BaseModel() {
    // Empty constructor for initialization
  }

  DateTime? formatFromDateTime(String? date) {
    return date != null ? DateTime.parse(date) : null;
  }

  String? formatToDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd').format(date) : null;
  }

  String? formatToDateTime(DateTime? date) {
    return date?.toString();
  }

  fromBaseJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    deletedAt =
        json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null;
  }

  Map<String, dynamic> toBaseJson() {
    return {
      'id': id,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'deleted_at': deletedAt != null ? deletedAt.toString() : '',
    };
  }
}
