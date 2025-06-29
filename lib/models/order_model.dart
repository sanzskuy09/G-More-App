import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'order_model.g.dart';

@HiveType(typeId: 1)
class OrderModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? cabang;

  @HiveField(2)
  final String? statusperkawinan; // Nama disesuaikan dengan JSON

  @HiveField(3)
  final int? jeniskelamin;

  @HiveField(4)
  final int? umur; // Tipe data diubah ke int

  @HiveField(5)
  final String? nama;

  @HiveField(6)
  final String? nik;

  @HiveField(7)
  final String? tempatlahir;

  @HiveField(8)
  final DateTime? tgllahir;

  @HiveField(9)
  final String? alamat;

  @HiveField(10)
  final String? rt;

  @HiveField(11)
  final String? rw;

  @HiveField(12)
  final String? kel;

  @HiveField(13)
  final String? kec;

  @HiveField(14)
  final String? provinsi;

  @HiveField(15)
  final String? kodepos;

  @HiveField(16)
  Uint8List? fotoktp;

  @HiveField(17) // Anotasi ditambahkan
  final String? namapasangan;

  @HiveField(18)
  final String? nikpasangan;

  @HiveField(19)
  final String? tempatlahirpasangan;

  @HiveField(20)
  final DateTime? tgllahirpasangan;

  @HiveField(21)
  final String? alamatpasangan;

  @HiveField(22)
  final String? rtpasangan;

  @HiveField(23)
  final String? rwpasangan;

  @HiveField(24)
  final String? kelpasangan;

  @HiveField(25)
  final String? kecpasangan;

  @HiveField(26)
  final String? provinsipasangan;

  @HiveField(27)
  final String? kodepospasangan;

  @HiveField(28)
  Uint8List? fotoktppasangan;

  @HiveField(29)
  bool? isSynced;

  @HiveField(30)
  String? statusslik;

  @HiveField(31)
  String? dealer;

  @HiveField(32)
  String? catatan;

  @HiveField(33)
  String? kota;

  @HiveField(34)
  String? kotapasangan;

  @HiveField(35)
  int? is_survey;

  OrderModel({
    this.id,
    this.cabang,
    this.statusperkawinan,
    this.jeniskelamin,
    this.umur,
    this.nama,
    this.nik,
    this.tempatlahir,
    this.tgllahir,
    this.alamat,
    this.rt,
    this.rw,
    this.kel,
    this.kec,
    this.kota,
    this.provinsi,
    this.kodepos,
    this.fotoktp,
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
    this.isSynced = false,
    this.statusslik,
    this.dealer,
    this.catatan,
    this.is_survey,
  });

  // Method toJson yang lebih lengkap
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cabang': cabang,
      'statusperkawinan': statusperkawinan,
      'nik': nik,
      'nama': nama,
      'tempatlahir': tempatlahir,
      'tgllahir': tgllahir?.toIso8601String(),
      'alamat': alamat,
      'rt': rt,
      'rw': rw,
      'kel': kel,
      'kec': kec,
      'kota': kota,
      'provinsi': provinsi,
      'dealer': dealer,
      'catatan': catatan,
      'statusslik': statusslik,
      'nikpasangan': nikpasangan,
      'namapasangan': namapasangan,
      'tempatlahirpasangan': tempatlahirpasangan,
      'tgllahirpasangan': tgllahirpasangan?.toIso8601String(),
      'alamatpasangan': alamatpasangan,
      'rtpasangan': rtpasangan,
      'rwpasangan': rwpasangan,
      'kelpasangan': kelpasangan,
      'kecpasangan': kecpasangan,
      'kotapasangan': kotapasangan,
      'provinsipasangan': provinsipasangan,
      'umur': umur,
      'jeniskelamin': jeniskelamin,
      'is_survey': is_survey,
      // Foto biasanya di-handle terpisah (misalnya di-upload sebagai multipart/form-data)
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      statusslik: json['statusslik'],
      cabang: json['cabang'],
      statusperkawinan: json['statusperkawinan'],
      jeniskelamin: json['jeniskelamin'],
      umur: json['umur'],
      nama: json['nama'],
      nik: json['nik'],
      tempatlahir: json['tempatlahir'],
      tgllahir:
          json['tgllahir'] == null ? null : DateTime.parse(json['tgllahir']),
      alamat: json['alamat'],
      rt: json['rt'],
      rw: json['rw'],
      kel: json['kel'],
      kec: json['kec'],
      kota: json['kota'],
      provinsi: json['provinsi'],
      kodepos: json['kodepos'],
      namapasangan: json['namapasangan'],
      nikpasangan: json['nikpasangan'],
      tempatlahirpasangan: json['tempatlahirpasangan'],
      tgllahirpasangan: json['tgllahirpasangan'] == null
          ? null
          : DateTime.parse(json['tgllahirpasangan']),
      alamatpasangan: json['alamatpasangan'],
      rtpasangan: json['rtpasangan'],
      rwpasangan: json['rwpasangan'],
      kelpasangan: json['kelpasangan'],
      kecpasangan: json['kecpasangan'],
      kotapasangan: json['kotapasangan'],
      provinsipasangan: json['provinsipasangan'],
      kodepospasangan: json['kodepospasangan'],
      dealer: json['dealer'],
      catatan: json['catatan'],
      is_survey: json['is_survey'],
    );
  }

  // Di dalam class OrderModel

// ... (setelah constructor atau fromJson)

  OrderModel copyWith({
    int? id,
    String? cabang,
    String? statusperkawinan,
    int? jeniskelamin,
    int? umur,
    String? nama,
    String? nik,
    String? tempatlahir,
    DateTime? tgllahir,
    String? alamat,
    String? rt,
    String? rw,
    String? kel,
    String? kec,
    String? provinsi,
    String? kodepos,
    Uint8List? fotoktp,
    String? namapasangan,
    String? nikpasangan,
    String? tempatlahirpasangan,
    DateTime? tgllahirpasangan,
    String? alamatpasangan,
    String? rtpasangan,
    String? rwpasangan,
    String? kelpasangan,
    String? kecpasangan,
    String? provinsipasangan,
    String? kodepospasangan,
    Uint8List? fotoktppasangan,
    bool? isSynced, // Parameter yang ingin kita ubah
    String? statusslik,
    String? dealer,
    String? catatan,
    String? kota,
    String? kotapasangan,
    int? is_survey,
  }) {
    return OrderModel(
      id: id ?? this.id,
      cabang: cabang ?? this.cabang,
      statusperkawinan: statusperkawinan ?? this.statusperkawinan,
      jeniskelamin: jeniskelamin ?? this.jeniskelamin,
      umur: umur ?? this.umur,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      tempatlahir: tempatlahir ?? this.tempatlahir,
      tgllahir: tgllahir ?? this.tgllahir,
      alamat: alamat ?? this.alamat,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      kel: kel ?? this.kel,
      kec: kec ?? this.kec,
      provinsi: provinsi ?? this.provinsi,
      kodepos: kodepos ?? this.kodepos,
      fotoktp: fotoktp ?? this.fotoktp,
      namapasangan: namapasangan ?? this.namapasangan,
      nikpasangan: nikpasangan ?? this.nikpasangan,
      tempatlahirpasangan: tempatlahirpasangan ?? this.tempatlahirpasangan,
      tgllahirpasangan: tgllahirpasangan ?? this.tgllahirpasangan,
      alamatpasangan: alamatpasangan ?? this.alamatpasangan,
      rtpasangan: rtpasangan ?? this.rtpasangan,
      rwpasangan: rwpasangan ?? this.rwpasangan,
      kelpasangan: kelpasangan ?? this.kelpasangan,
      kecpasangan: kecpasangan ?? this.kecpasangan,
      provinsipasangan: provinsipasangan ?? this.provinsipasangan,
      kodepospasangan: kodepospasangan ?? this.kodepospasangan,
      fotoktppasangan: fotoktppasangan ?? this.fotoktppasangan,
      isSynced: isSynced ?? this.isSynced, // Gunakan nilai baru jika ada
      statusslik: statusslik ?? this.statusslik,
      dealer: dealer ?? this.dealer,
      catatan: catatan ?? this.catatan,
      kota: kota ?? this.kota,
      kotapasangan: kotapasangan ?? this.kotapasangan,
      is_survey: is_survey ?? this.is_survey,
    );
  }
}
