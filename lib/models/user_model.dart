class UserModel {
  int? id;
  String? name;
  String? email;
  String? nik;
  String? username;
  String? password;
  String? role;
  String? photoUrl;
  String? token;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.nik,
    this.username,
    this.password,
    this.role,
    this.photoUrl,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        nik: json['nik'],
        username: json['username'],
        password: json['password'],
        role: json['role'],
        photoUrl: json['photoUrl'],
        token: json['token'],
      );

  UserModel copyWith({
    String? name,
    String? email,
    String? nik,
    String? username,
    String? password,
    String? role,
    String? photoUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      nik: nik ?? this.nik,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      token: token,
    );
  }
}
