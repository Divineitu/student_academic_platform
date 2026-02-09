// A model for defining representing sessions with scheduling details and attendance tracking.
// Attendace marked false by default and location is an optional parameter.

class Session {
  String id;
  String title;
  String date;
  String startTime;
  String endTime;
  String location;
  String sessionType;
  bool isPresent;

  Session({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',
    required this.sessionType,
    this.isPresent = false,
  });
}
