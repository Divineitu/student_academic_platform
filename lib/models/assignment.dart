
enum AssignmentPriority { high, medium, low }

class Assignment {
  final String id;
  final String title;
  final DateTime dueDate;
  final String courseName;
  final AssignmentPriority priority;
  final bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.dueDate,
    this.courseName = '',
    this.priority = AssignmentPriority.medium,
    this.isCompleted = false,
  });

  Assignment copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    String? courseName,
    AssignmentPriority? priority,
    bool? isCompleted,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      courseName: courseName ?? this.courseName,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
