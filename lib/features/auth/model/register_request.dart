class RegisterRequest {
  final String username;
  final String password;

  RegisterRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}