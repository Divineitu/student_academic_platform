import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../models/session.dart';
import '../services/attendance_service.dart';
import '../widgets/stats_card.dart';
import '../utils/date_utils.dart' as date_utils;
import 'profile.dart';

class DashboardScreen extends StatelessWidget {
  final List<Assignment> assignments;
  final List<Session> sessions;
  final String userName;
  final String userEmail;

  const DashboardScreen({
    super.key,
    required this.assignments,
    required this.sessions,
    required this.userName,
    required this.userEmail,
  });

  int getCurrentWeek() {
    DateTime now = DateTime.now();
    int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return (dayOfYear / 7).ceil();
  }

  String getTodayDate() {
    return date_utils.AppDateUtils.formatDate(
      DateTime.now(),
      format: 'EEEE, MMM dd, yyyy',
    );
  }

  int getPendingCount() {
    return assignments.where((a) => !a.isCompleted).length;
  }

  List<Session> getTodaySessions() {
    String today = date_utils.AppDateUtils.formatDate(
      DateTime.now(),
      format: 'MMM dd, yyyy',
    );
    return sessions.where((s) => s.date == today).toList();
  }

  List<Assignment> getUpcomingAssignments() {
    DateTime now = DateTime.now();
    DateTime weekFromNow = now.add(const Duration(days: 7));

    return assignments.where((assignment) {
      if (assignment.isCompleted) return false;
      try {
        DateTime dueDate = date_utils.AppDateUtils.parse(assignment.dueDate);
        return dueDate.isAfter(now.subtract(const Duration(days: 1))) &&
            dueDate.isBefore(weekFromNow.add(const Duration(days: 1)));
      } catch (e) {
        return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double attendance = AttendanceService.calculateAttendance(sessions);
    bool isAtRisk = AttendanceService.isAttendanceAtRisk(sessions);
    int pendingCount = getPendingCount();

    return Scaffold(
      backgroundColor: const Color(0xFF1B2C5C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2C5C),
        elevation: 0,
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    userName: userName,
                    userEmail: userEmail,
                    sessions: sessions,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateCard(),
            const SizedBox(height: 20),
            if (isAtRisk) _buildWarningCard(attendance),
            if (isAtRisk) const SizedBox(height: 20),
            _buildStatsCards(attendance, pendingCount),
            const SizedBox(height: 20),
            _buildTodaysSessions(),
            const SizedBox(height: 20),
            _buildUpcomingAssignments(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTodayDate(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Week ${getCurrentWeek()}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(Icons.calendar_today, color: Color(0xFFFFB800), size: 30),
        ],
      ),
    );
  }

  Widget _buildWarningCard(double attendance) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD32F2F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.white, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AT RISK WARNING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Attendance: ${attendance.toInt()}% (Below 75%)',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(double attendance, int pendingCount) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            value: '${attendance.toInt()}%',
            label: 'Attendance',
            backgroundColor: attendance >= 75
                ? const Color(0xFF4CAF50)
                : const Color(0xFFD32F2F),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsCard(
            value: '$pendingCount',
            label: 'Pending Tasks',
            backgroundColor: const Color(0xFFFFB800),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysSessions() {
    List<Session> todaySessions = getTodaySessions();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Classes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (todaySessions.isEmpty)
          _buildEmptyCard('No classes scheduled for today')
        else
          ...todaySessions.map((session) => _buildSessionCard(session)),
      ],
    );
  }

  Widget _buildUpcomingAssignments() {
    List<Assignment> upcoming = getUpcomingAssignments();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assignments Due Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (upcoming.isEmpty)
          _buildEmptyCard('No upcoming assignments')
        else
          ...upcoming
              .take(5)
              .map((assignment) => _buildAssignmentCard(assignment)),
      ],
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSessionCard(Session session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB800),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.class_, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.startTime} - ${session.endTime}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                if (session.location.isNotEmpty)
                  Text(
                    session.location,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    Color priorityColor = assignment.priority == 'High'
        ? const Color(0xFFD32F2F)
        : assignment.priority == 'Medium'
        ? const Color(0xFFFFA000)
        : const Color(0xFF4CAF50);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 50, color: priorityColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  assignment.course,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                assignment.dueDate,
                style: const TextStyle(color: Color(0xFFFFB800), fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                assignment.priority,
                style: TextStyle(color: priorityColor, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
