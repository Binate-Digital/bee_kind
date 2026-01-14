class LoginDataModel {
  final String email;
  final String password;
  final String role;
  final String deviceToken;

  LoginDataModel({
    required this.email,
    required this.password,
    required this.role,
    required this.deviceToken,
  });



  Map<String, dynamic> toJson() {
    return {"email": email, "password": password, "role": role,"deviceToken":deviceToken};
  }

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      role: json["role"] ?? "",
      deviceToken: json["deviceToken"] ?? "",
    );
  }

  @override
  String toString() =>
      'LoginDataModel(email: $email, password: $password, role: "$role")';
}
