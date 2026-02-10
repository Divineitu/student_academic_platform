class ValidationService {
  // Check if email is valid
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Check if password is valid (minimum 6 characters)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
