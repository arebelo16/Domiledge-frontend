class AuthValidators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!re.hasMatch(value.trim())) return 'Invalid email format';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required';
    if (value.contains(' ')) return 'Username must not contain spaces';
    if (value.length < 3 || value.length > 20) {
      return 'Username must be between 3 and 20 characters';
    }
    final re = RegExp(r'^[a-zA-Z0-9_.-]+$');
    if (!re.hasMatch(value)) {
      return 'Only letters, numbers, ., _ and - are allowed';
    }
    return null;
  }

  static String? usernameOrEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username or email is required';
    }
    if (value.contains('@')) {
      return email(value);
    } else {
      return username(value);
    }
  }

  static String? confirmPassword(String? passwordValue, String? confirmValue) {
    if (confirmValue == null || confirmValue.isEmpty) {
      return 'Password confirmation is required';
    }
    if (passwordValue != confirmValue) return 'Passwords do not match';
    return null;
  }

  static String? loginPassword(String? value) => password(value);

  static String? validateLoginPassword(String? value) => loginPassword(value);
}
