import 'package:flutter/material.dart';
import '../services/validation_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool isLogin = true;

  void handleSubmit() {
    if (isLogin) {
      // Login validation
      if (!ValidationService.isValidEmail(emailController.text)) {
        _showError('Please enter a valid email address');
        return;
      }
      if (!ValidationService.isValidPassword(passwordController.text)) {
        _showError('Password must be at least 6 characters');
        return;
      }
      _navigateToHome();
    } else {
      // Register validation
      if (nameController.text.isEmpty) {
        _showError('Please enter your name');
        return;
      }
      if (!ValidationService.isValidEmail(emailController.text)) {
        _showError('Please enter a valid email address');
        return;
      }
      if (!ValidationService.isValidPassword(passwordController.text)) {
        _showError('Password must be at least 6 characters');
        return;
      }
      _navigateToHome();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NavigationScreen(
          userName: isLogin ? emailController.text.split('@')[0] : nameController.text,
          userEmail: emailController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2C5C),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 30),
                _buildTitle(),
                const SizedBox(height: 40),
                if (!isLogin) ...[
                  CustomTextField(
                    controller: nameController,
                    label: 'Full Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                ],
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: isLogin ? 'Login' : 'Register',
                  onPressed: handleSubmit,
                ),
                const SizedBox(height: 20),
                _buildToggle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFFFB800),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.school, size: 60, color: Colors.white),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        const Text(
          'ALU Student Assistant',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          isLogin ? 'Login to your account' : 'Create new account',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin ? 'Don\'t have an account?' : 'Already have an account?',
          style: const TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isLogin = !isLogin;
              nameController.clear();
              emailController.clear();
              passwordController.clear();
            });
          },
          child: Text(
            isLogin ? 'Register' : 'Login',
            style: const TextStyle(color: Color(0xFFFFB800), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
