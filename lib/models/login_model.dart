class LoginModel {
  String? username;
  String? password;
  // String? nik;
  // String? potoProfile;
  // String? jabatan;

  LoginModel({
    this.username,
    this.password,
    // this.nik,
    // this.potoProfile,
    // this.jabatan,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      // 'nik': nik,
      // 'poto_profile': potoProfile,
      // 'jabatan': jabatan
    };
  }

  LoginModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    // nik = json['nik'];
    // potoProfile = json['poto_profile'];
    // jabatan = json['jabatan'];
  }
}
