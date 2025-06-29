import 'dart:convert';

import 'package:gmore/models/order_model.dart';
import 'package:gmore/shared/shared_value.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

class OrderServices {
  // get data
  Future<List<OrderModel>> getData() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/pemohon'));

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

  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      // 1. Buat MultipartRequest, bukan http.post biasa
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/pemohon'), // Pastikan endpoint ini benar
      );

      // 2. Tambahkan semua data teks sebagai 'fields'
      // Pastikan key-nya ('nama', 'nik', dll) sama persis dengan yang diharapkan backend
      request.fields['cabang'] = order.cabang ?? '';
      request.fields['statusperkawinan'] = order.statusperkawinan ?? '';
      // pemohon
      request.fields['umur'] = order.umur?.toString() ?? '';
      request.fields['nik'] = order.nik ?? '';
      request.fields['nama'] = order.nama ?? '';
      request.fields['tempatlahir'] = order.tempatlahir ?? '';

      if (order.tgllahir != null) {
        request.fields['tgllahir'] =
            DateFormat('yyyy-MM-dd').format(order.tgllahir!);
      }
      request.fields['jeniskelamin'] = order.jeniskelamin?.toString() ?? '';
      request.fields['alamat'] = order.alamat ?? '';
      request.fields['rt'] = order.rt ?? '';
      request.fields['rw'] = order.rw ?? '';
      request.fields['kel'] = order.kel ?? '';
      request.fields['kec'] = order.kec ?? '';
      request.fields['kota'] = order.kota ?? '';
      request.fields['provinsi'] = order.provinsi ?? '';
      request.fields['kodepos'] = order.kodepos ?? '';
      // pasangan
      request.fields['nikpasangan'] = order.nikpasangan ?? '';
      request.fields['namapasangan'] = order.namapasangan ?? '';
      request.fields['tempatlahirpasangan'] = order.tempatlahirpasangan ?? '';
      if (order.tgllahirpasangan != null) {
        request.fields['tgllahirpasangan'] =
            DateFormat('yyyy-MM-dd').format(order.tgllahirpasangan!);
      }
      request.fields['alamatpasangan'] = order.alamatpasangan ?? '';
      request.fields['rtpasangan'] = order.rtpasangan ?? '';
      request.fields['rwpasangan'] = order.rwpasangan ?? '';
      request.fields['kelpasangan'] = order.kelpasangan ?? '';
      request.fields['kecpasangan'] = order.kecpasangan ?? '';
      request.fields['kotapasangan'] = order.kotapasangan ?? '';
      request.fields['provinsipasangan'] = order.provinsipasangan ?? '';
      request.fields['kodepospasangan'] = order.kodepospasangan ?? '';

      // Tambahkan semua field teks lainnya dengan cara yang sama...
      request.fields['statusslik'] = order.statusslik ?? 'PENDING';
      request.fields['dealer'] = order.dealer ?? '';
      request.fields['catatan'] = order.catatan ?? '';
      request.fields['is_survey'] = 0.toString();

      // 3. Tambahkan gambar sebagai 'files' jika tidak null
      if (order.fotoktp != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'fotoktp', // Nama field untuk file di backend
            order.fotoktp!,
            filename: '${order.nik}_ktp.jpg', // Beri nama file yang deskriptif
            contentType: MediaType('image', 'jpeg'), // Tentukan tipe konten
          ),
        );
      }

      if (order.fotoktppasangan != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'fotoktppasangan', // Nama field untuk file di backend
            order.fotoktppasangan!,
            filename: '${order.nikpasangan}_ktp.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      // 4. Kirim request dan tunggu respons
      var streamedResponse = await request.send();

      // 5. Ubah StreamedResponse menjadi Response biasa untuk dibaca
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Jika berhasil, parse body respons seperti biasa
        return OrderModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Gagal membuat order: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
