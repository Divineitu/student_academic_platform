// This is for navigation screen - Divine Itu

import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../models/session.dart';
import '../services/data_service.dart';
import 'dashboard.dart';
import 'assignments.dart';
import 'scheduling.dart';

class NavigationScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const NavigationScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;
  List<Assignment> assignments = [];
  List<Session> sessions = [];

  @override
  void initState() {
    super.initState();
    assignments = DataService.getSampleAssignments();
    sessions = DataService.getSampleSessions();
  }

  void addAssignment(Assignment assignment) {
    setState(() => assignments.add(assignment));
  }

  void updateAssignment(Assignment assignment) {
    setState(() {
      int index = assignments.indexWhere((a) => a.id == assignment.id);
      if (index != -1) assignments[index] = assignment;
    });
  }

  void deleteAssignment(String id) {
    setState(() => assignments.removeWhere((a) => a.id == id));
  }

  void addSession(Session session) {
    setState(() => sessions.add(session));
  }

  void updateSession(Session session) {
    setState(() {
      int index = sessions.indexWhere((s) => s.id == session.id);
      if (index != -1) sessions[index] = session;
    });
  }

  void deleteSession(String id) {
    setState(() => sessions.removeWhere((s) => s.id == id));
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        assignments: assignments,
        sessions: sessions,
        userName: widget.userName,
        userEmail: widget.userEmail,
      ),
      AssignmentsScreen(
        assignments: assignments,
        onAdd: addAssignment,
        onUpdate: updateAssignment,
        onDelete: deleteAssignment,
      ),
      SchedulingScreen(
        sessions: sessions,
        onAdd: addSession,
        onUpdate: updateSession,
        onDelete: deleteSession,
      ),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        backgroundColor: const Color(0xFF1B2C5C),
        selectedItemColor: const Color(0xFFFFB800),
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Assignments'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
        ],
      ),
    );
  }
}
