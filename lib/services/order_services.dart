import 'dart:convert';

import 'package:gmore/models/order_model.dart';
import 'package:gmore/shared/shared_value.dart';
import 'package:http/http.dart' as http;

class OrderServices {
  // get data
  Future<List<OrderModel>> getData() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/pemohon'));

      print('Get data order');

      if (res.statusCode == 200) {
        final List<dynamic> body = jsonDecode(res.body);

        // Konversi setiap item dalam list menjadi OrderModel dan kembalikan sebagai List
        // Tambahkan "as Map<String, dynamic>" untuk type safety
        return body
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(jsonDecode(res.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
