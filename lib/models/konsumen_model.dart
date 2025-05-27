import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'konsumen_model.g.dart';

@HiveType(typeId: 0)
class KonsumenModel extends HiveObject {
  @HiveField(0)
  String nik;

  @HiveField(1)
  String nama;

  @HiveField(2)
  String tempat;

  @HiveField(3)
  String tglLahir;

  @HiveField(4)
  String alamat;

  @HiveField(5)
  String showRoom;

  @HiveField(6)
  String catatan;

  @HiveField(7)
  String status;

  @HiveField(8)
  Uint8List? fotoKtp;

  @HiveField(9)
  String? nikPasangan;

  @HiveField(10)
  String? namaPasangan;

  @HiveField(11)
  String? tempatPasangan;

  @HiveField(12)
  String? tglLahirPasangan;

  @HiveField(13)
  String? alamatPasangan;

  @HiveField(14)
  Uint8List? fotoKtpPasangan;

  @HiveField(15)
  String? statusPernikahan;

  KonsumenModel({
    required this.nik,
    required this.nama,
    required this.tempat,
    required this.tglLahir,
    required this.alamat,
    required this.showRoom,
    required this.catatan,
    required this.status,
    this.statusPernikahan,
    this.fotoKtp,
    this.nikPasangan,
    this.namaPasangan,
    this.tempatPasangan,
    this.tglLahirPasangan,
    this.alamatPasangan,
    this.fotoKtpPasangan,
  });
}
