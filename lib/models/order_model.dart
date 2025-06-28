import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'order_model.g.dart';

@HiveType(typeId: 1)
class OrderModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String cabang;
  @HiveField(2)
  final String statuspernikahan;
  @HiveField(3)
  final int jeniskelamin;
  @HiveField(4)
  final String umur;
  @HiveField(5)
  final String nama;
  @HiveField(6)
  final String nik;
  @HiveField(7)
  final String tempatlahir;
  @HiveField(8)
  final String tgllahir;
  @HiveField(9)
  final String alamat;
  @HiveField(10)
  final String rt;
  @HiveField(11)
  final String rw;
  @HiveField(12)
  final String kel;
  @HiveField(13)
  final String kec;
  @HiveField(14)
  final String provinsi;
  @HiveField(15)
  final String kodepos;
  @HiveField(16)
  Uint8List? fotoktp;

  final String? namapasangan;
  @HiveField(17)
  final String? nikpasangan;
  @HiveField(18)
  final String? tempatlahirpasangan;
  @HiveField(19)
  final String? tgllahirpasangan;
  @HiveField(20)
  final String? alamatpasangan;
  @HiveField(21)
  final String? rtpasangan;
  @HiveField(22)
  final String? rwpasangan;
  @HiveField(23)
  final String? kelpasangan;
  @HiveField(24)
  final String? kecpasangan;
  @HiveField(25)
  final String? provinsipasangan;
  @HiveField(26)
  final String? kodepospasangan;
  @HiveField(27)
  Uint8List? fotoktppasangan;

  @HiveField(28)
  bool? isSynced;

  @HiveField(29)
  String statusslik;
  @HiveField(30)
  String? dealer;
  @HiveField(31)
  String? catatan;

  @HiveField(32)
  String? kota;
  @HiveField(33)
  String? kotapasangan;

  OrderModel({
    this.id,
    required this.cabang,
    required this.statuspernikahan,
    // pemohon
    required this.jeniskelamin,
    required this.umur,
    required this.nama,
    required this.nik,
    required this.tempatlahir,
    required this.tgllahir,
    required this.alamat,
    required this.rt,
    required this.rw,
    required this.kel,
    required this.kec,
    this.kota,
    required this.provinsi,
    required this.kodepos,
    this.fotoktp,
    // pasangan
    this.namapasangan,
    this.nikpasangan,
    this.tempatlahirpasangan,
    this.tgllahirpasangan,
    this.alamatpasangan,
    this.rtpasangan,
    this.rwpasangan,
    this.kelpasangan,
    this.kecpasangan,
    this.kotapasangan,
    this.provinsipasangan,
    this.kodepospasangan,
    this.fotoktppasangan,
    // sync
    this.isSynced = false,
    required this.statusslik,
    this.dealer,
    this.catatan,
  });

  Map<String, dynamic> toJson() {
    return {
      'statusslik': statusslik,
      'cabang': cabang,
      'statuspernikahan': statuspernikahan,
      'jeniskelamin': jeniskelamin,
      'umur': umur,
      'nama': nama,
      'nik': nik,
      'tempatlahir': tempatlahir,
      'tgllahir': tgllahir,
      'alamat': alamat,
      'rt': rt,
      'rw': rw,
      'kel': kel,
      'kec': kec,
      'kota': kota,
      'provinsi': provinsi,
      'kodepos': kodepos,
      'namapasangan': namapasangan,
      'nikpasangan': nikpasangan,
      'tempatlahirpasangan': tempatlahirpasangan,
      'tgllahirpasangan': tgllahirpasangan,
      'alamatpasangan': alamatpasangan,
      'rtpasangan': rtpasangan,
      'rwpasangan': rwpasangan,
      'kelpasangan': kelpasangan,
      'kecpasangan': kecpasangan,
      'kotapasangan': kotapasangan,
      'provinsipasangan': provinsipasangan,
      'kodepospasangan': kodepospasangan,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      statusslik: json['statusslik'],
      cabang: json['cabang'],
      statuspernikahan: json['statuspernikahan'],
      // pemohon
      jeniskelamin: json['jeniskelamin'],
      umur: json['umur'],
      nama: json['nama'],
      nik: json['nik'],
      tempatlahir: json['tempatlahir'],
      tgllahir: json['tgllahir'],
      alamat: json['alamat'],
      rt: json['rt'],
      rw: json['rw'],
      kel: json['kel'],
      kec: json['kec'],
      kota: json['kota'],
      provinsi: json['provinsi'],
      kodepos: json['kodepos'],
      // pasangan
      namapasangan: json['namapasangan'],
      nikpasangan: json['nikpasangan'],
      tempatlahirpasangan: json['tempatlahirpasangan'],
      tgllahirpasangan: json['tgllahirpasangan'],
      alamatpasangan: json['alamatpasangan'],
      rtpasangan: json['rtpasangan'],
      rwpasangan: json['rwpasangan'],
      kelpasangan: json['kelpasangan'],
      kecpasangan: json['kecpasangan'],
      kotapasangan: json['kotapasangan'],
      provinsipasangan: json['provinsipasangan'],
      kodepospasangan: json['kodepospasangan'],
      //delaer
      dealer: json['dealer'],
      catatan: json['catatan'],
    );
  }
}
