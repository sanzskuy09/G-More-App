import 'dart:convert';

import 'package:gmore/models/login_model.dart';
import 'package:gmore/shared/shared_value.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  Future<LoginModel> login(LoginModel data) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        body: data.toJson(),
        // headers: {
        //   'Content-Type': 'application/json',
        // },
        // body: jsonEncode(data.toJson()),
      );

      if (res.statusCode == 200) {
        LoginModel user = LoginModel.fromJson(jsonDecode(res.body));

        return user;
      } else {
        throw Exception(jsonDecode(res.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
