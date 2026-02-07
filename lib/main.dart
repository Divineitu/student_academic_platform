import 'package:flutter/material.dart';
import 'screens/assignment_manager_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Academic Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003366), // ALU Navy
          primary: const Color(0xFF003366),
          secondary: const Color(0xFFFFCC00), // ALU Gold
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003366),
          foregroundColor: Colors.white,
        ),
      ),
      home: const AssignmentManagerScreen(),
    );
  }
}

