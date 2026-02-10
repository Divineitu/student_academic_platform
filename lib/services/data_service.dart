import '../models/assignment.dart';
import '../models/session.dart';

class DataService {
  // Sample assignments
  static List<Assignment> getSampleAssignments() {
    return [
      Assignment(
        id: '1',
        title: 'Mobile App Project',
        course: 'Mobile Development',
        dueDate: 'Feb 15, 2026',
        priority: 'High',
      ),
    ];
  }

  // Sample sessions
  static List<Session> getSampleSessions() {
    return [
      Session(
        id: '1',
        title: 'Mobile Development',
        date: 'Feb 08, 2026',
        startTime: '9:00 AM',
        endTime: '11:00 AM',
        location: 'Room 101',
        sessionType: 'Class',
      ),
    ];
  }
}
