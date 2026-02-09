// A data model representing assignments with an id, title,
// due date and priority which defaults to medium

class Assignment {
  String id;
  String title;
  String course;
  String dueDate;
  String priority;
  bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    this.priority = 'Medium',
    this.isCompleted = false,
  });
}
