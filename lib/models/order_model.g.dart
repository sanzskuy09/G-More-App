// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 1;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as int?,
      cabang: fields[1] as String,
      statuspernikahan: fields[2] as String,
      jeniskelamin: fields[3] as int,
      umur: fields[4] as String,
      nama: fields[5] as String,
      nik: fields[6] as String,
      tempatlahir: fields[7] as String,
      tgllahir: fields[8] as String,
      alamat: fields[9] as String,
      rt: fields[10] as String,
      rw: fields[11] as String,
      kel: fields[12] as String,
      kec: fields[13] as String,
      kota: fields[32] as String?,
      provinsi: fields[14] as String,
      kodepos: fields[15] as String,
      fotoktp: fields[16] as Uint8List?,
      nikpasangan: fields[17] as String?,
      tempatlahirpasangan: fields[18] as String?,
      tgllahirpasangan: fields[19] as String?,
      alamatpasangan: fields[20] as String?,
      rtpasangan: fields[21] as String?,
      rwpasangan: fields[22] as String?,
      kelpasangan: fields[23] as String?,
      kecpasangan: fields[24] as String?,
      kotapasangan: fields[33] as String?,
      provinsipasangan: fields[25] as String?,
      kodepospasangan: fields[26] as String?,
      fotoktppasangan: fields[27] as Uint8List?,
      isSynced: fields[28] as bool?,
      statusslik: fields[29] as String,
      dealer: fields[30] as String?,
      catatan: fields[31] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cabang)
      ..writeByte(2)
      ..write(obj.statuspernikahan)
      ..writeByte(3)
      ..write(obj.jeniskelamin)
      ..writeByte(4)
      ..write(obj.umur)
      ..writeByte(5)
      ..write(obj.nama)
      ..writeByte(6)
      ..write(obj.nik)
      ..writeByte(7)
      ..write(obj.tempatlahir)
      ..writeByte(8)
      ..write(obj.tgllahir)
      ..writeByte(9)
      ..write(obj.alamat)
      ..writeByte(10)
      ..write(obj.rt)
      ..writeByte(11)
      ..write(obj.rw)
      ..writeByte(12)
      ..write(obj.kel)
      ..writeByte(13)
      ..write(obj.kec)
      ..writeByte(14)
      ..write(obj.provinsi)
      ..writeByte(15)
      ..write(obj.kodepos)
      ..writeByte(16)
      ..write(obj.fotoktp)
      ..writeByte(17)
      ..write(obj.nikpasangan)
      ..writeByte(18)
      ..write(obj.tempatlahirpasangan)
      ..writeByte(19)
      ..write(obj.tgllahirpasangan)
      ..writeByte(20)
      ..write(obj.alamatpasangan)
      ..writeByte(21)
      ..write(obj.rtpasangan)
      ..writeByte(22)
      ..write(obj.rwpasangan)
      ..writeByte(23)
      ..write(obj.kelpasangan)
      ..writeByte(24)
      ..write(obj.kecpasangan)
      ..writeByte(25)
      ..write(obj.provinsipasangan)
      ..writeByte(26)
      ..write(obj.kodepospasangan)
      ..writeByte(27)
      ..write(obj.fotoktppasangan)
      ..writeByte(28)
      ..write(obj.isSynced)
      ..writeByte(29)
      ..write(obj.statusslik)
      ..writeByte(30)
      ..write(obj.dealer)
      ..writeByte(31)
      ..write(obj.catatan)
      ..writeByte(32)
      ..write(obj.kota)
      ..writeByte(33)
      ..write(obj.kotapasangan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
