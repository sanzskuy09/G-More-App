import 'dart:convert';

import 'package:gmore/models/order_model.dart';
import 'package:gmore/shared/shared_value.dart';
import 'package:http/http.dart' as http;

class OrderServices {
  // get data
  Future<OrderModel> getData(OrderModel data) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/pemohon'));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        return OrderModel.fromJson(body);
      } else {
        throw Exception(jsonDecode(res.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
