class SignUpDataModel {
  final String email;
  final String password;
  final String role;

  SignUpDataModel({
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "role": role,
    };
  }

  factory SignUpDataModel.fromJson(Map<String, dynamic> json) {
    return SignUpDataModel(
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      role: json["role"] ?? "",
    );
  }

  @override
  String toString() =>
      'SignUpDataModel(email: $email, password: $password, role: $role)';
}
