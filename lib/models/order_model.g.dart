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
      cabang: fields[1] as String?,
      statusperkawinan: fields[2] as String?,
      jeniskelamin: fields[3] as int?,
      umur: fields[4] as int?,
      nama: fields[5] as String?,
      nik: fields[6] as String?,
      tempatlahir: fields[7] as String?,
      tgllahir: fields[8] as DateTime?,
      alamat: fields[9] as String?,
      rt: fields[10] as String?,
      rw: fields[11] as String?,
      kel: fields[12] as String?,
      kec: fields[13] as String?,
      kota: fields[33] as String?,
      provinsi: fields[14] as String?,
      kodepos: fields[15] as String?,
      fotoktp: fields[16] as Uint8List?,
      namapasangan: fields[17] as String?,
      nikpasangan: fields[18] as String?,
      tempatlahirpasangan: fields[19] as String?,
      tgllahirpasangan: fields[20] as DateTime?,
      alamatpasangan: fields[21] as String?,
      rtpasangan: fields[22] as String?,
      rwpasangan: fields[23] as String?,
      kelpasangan: fields[24] as String?,
      kecpasangan: fields[25] as String?,
      kotapasangan: fields[34] as String?,
      provinsipasangan: fields[26] as String?,
      kodepospasangan: fields[27] as String?,
      fotoktppasangan: fields[28] as Uint8List?,
      isSynced: fields[29] as bool?,
      statusslik: fields[30] as String?,
      dealer: fields[31] as String?,
      catatan: fields[32] as String?,
      is_survey: fields[35] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(36)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cabang)
      ..writeByte(2)
      ..write(obj.statusperkawinan)
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
      ..write(obj.namapasangan)
      ..writeByte(18)
      ..write(obj.nikpasangan)
      ..writeByte(19)
      ..write(obj.tempatlahirpasangan)
      ..writeByte(20)
      ..write(obj.tgllahirpasangan)
      ..writeByte(21)
      ..write(obj.alamatpasangan)
      ..writeByte(22)
      ..write(obj.rtpasangan)
      ..writeByte(23)
      ..write(obj.rwpasangan)
      ..writeByte(24)
      ..write(obj.kelpasangan)
      ..writeByte(25)
      ..write(obj.kecpasangan)
      ..writeByte(26)
      ..write(obj.provinsipasangan)
      ..writeByte(27)
      ..write(obj.kodepospasangan)
      ..writeByte(28)
      ..write(obj.fotoktppasangan)
      ..writeByte(29)
      ..write(obj.isSynced)
      ..writeByte(30)
      ..write(obj.statusslik)
      ..writeByte(31)
      ..write(obj.dealer)
      ..writeByte(32)
      ..write(obj.catatan)
      ..writeByte(33)
      ..write(obj.kota)
      ..writeByte(34)
      ..write(obj.kotapasangan)
      ..writeByte(35)
      ..write(obj.is_survey);
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
