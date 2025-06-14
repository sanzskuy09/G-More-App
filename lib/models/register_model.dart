class RegisterModel {
  final String name;
  final String username;
  final String password;
  final String nik;
  final String role;

  RegisterModel({
    required this.name,
    required this.username,
    required this.password,
    required this.nik,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'username': username,
        'password': password,
        'nik': nik,
        'role': role,
      };
}
