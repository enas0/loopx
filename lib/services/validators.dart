// lib/services/validators.dart

class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Regular expression for email validation
    String pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? firstNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    }
    return null;
  }

  static String? lastNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    }
    return null;
  }
}
