import '../models/session.dart';

class AttendanceService {
  // Calculate attendance percentage
  static double calculateAttendance(List<Session> sessions) {
    if (sessions.isEmpty) return 0;
    int present = sessions.where((s) => s.isPresent).length;
    return (present / sessions.length) * 100;
  }

  // Check if attendance is at risk
  static bool isAttendanceAtRisk(List<Session> sessions) {
    return calculateAttendance(sessions) < 75;
  }
}
