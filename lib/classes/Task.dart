import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Task {
  String title;
  String task_description;
  String resolution_description;
  DateTime due_date;
  DateTime completed_date;
  DateTime created_at;
  var assigned_to;
  int created_by;
  int completed_by;
  String location;

  Task({this.title, this.task_description, this.resolution_description = null, this.due_date, this.completed_date = null, this.created_at, this.assigned_to=null, this.completed_by = null, this.location = null, this.created_by});




  Task.fromMap(Map taskMap): this(
      title: taskMap["title"],
      task_description: taskMap["task_description"],
      resolution_description: taskMap["resolution_description"],
      due_date: taskMap["due_date"]==null?null:DateTime.parse(taskMap["due_date"]),
      completed_date: taskMap["completed_date"]==null?null:DateTime.parse(taskMap["completed_date"]),

      assigned_to: taskMap["assigned_to"]==null?null:jsonDecode(taskMap["assigned_to"]),

      location: taskMap["location"],
      created_at: taskMap["created_at"]==null?null:DateTime.parse(taskMap["created_at"]),
      created_by: taskMap["created_by"]

  );

  get createdDate{
    return DateFormat.yMMMEd().format(created_at).toString();
  }

}