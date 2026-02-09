import 'package:flutter/material.dart';
import 'screens/login.dart';

void main() {
  runApp(const ALUApp());
}

class ALUApp extends StatelessWidget {
  const ALUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Student Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1B2C5C),
        scaffoldBackgroundColor: const Color(0xFF1B2C5C),
      ),
      home: const LoginScreen(),
    );
  }
}

