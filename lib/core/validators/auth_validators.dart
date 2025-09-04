class AuthValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirm) {
    if (confirm == null || confirm.isEmpty) {
      return 'Password confirmation is required';
    }
    if (password != confirm) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.contains(' ')) {
      return 'Username must not contain spaces';
    }
    if (value.length < 3 || value.length > 20) {
      return 'Username must be between 3 and 20 characters';
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_.-]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username contains invalid characters';
    }
    return null;
  }

  static String? validateLoginPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    return null;
  }
}
