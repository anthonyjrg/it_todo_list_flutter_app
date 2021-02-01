class Task {
  String title;
  String task_description;
  String resolution_description;
  DateTime due_date;
  DateTime completed_date;
  DateTime created_by;
  List<int> assigned_to;
  int completed_by;
  String location;

  Task({this.title, this.task_description, this.resolution_description = null, this.due_date, this.completed_date = null, this.created_by, this.assigned_to=null, this.completed_by = null, this.location = null});

  Task.fromMap(Map taskMap): this(
    title: taskMap["title"],
    task_description: taskMap["task_description"],
    resolution_description: taskMap["resolution_description"],
    location: taskMap["location"],
  );

}