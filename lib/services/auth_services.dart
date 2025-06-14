import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gmore/models/login_model.dart';
import 'package:gmore/models/register_model.dart';
import 'package:gmore/models/user_model.dart';
import 'package:gmore/shared/shared_value.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  // Register
  Future<UserModel> register(RegisterModel data) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        body: data.toJson(),
      );

      if (res.statusCode == 200) {
        UserModel user = UserModel.fromJson(jsonDecode(res.body));

        await storeCredential(user);

        return user;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> login(LoginModel data) async {
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
        final body = jsonDecode(res.body);
        final user = UserModel.fromJson(body['data']['user']);
        await storeCredential(user);

        return user;
      } else {
        throw Exception(jsonDecode(res.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> storeCredential(UserModel user) async {
    try {
      const storage = FlutterSecureStorage();

      await storage.write(key: 'username', value: user.username);
      await storage.write(key: 'token', value: user.token);
      // await storage.write(key: 'password', value: user.password);
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginModel> loginFromCredential() async {
    try {
      const storage = FlutterSecureStorage();

      Map<String, String> values = await storage.readAll();
      if (values['username'] != null && values['token'] != null) {
        throw 'Silahkan login terlebih dahulu';
      } else {
        // return LoginModel(username: values['username'], password: values['password']);
        final LoginModel data = LoginModel(
            username: values['username'], password: values['password']);
        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getToken() async {
    try {
      String token = '';
      const storage = FlutterSecureStorage();
      String? value = await storage.read(key: 'token');

      if (value != null) {
        token = value;
      }

      return 'Bearer $token';
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> verifyToken(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/auth/check'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return UserModel.fromJson(body['data']['user']);
    } else {
      throw Exception(jsonDecode(res.body)['message']);
    }
  }

  Future<void> clearAllStorage() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
}
