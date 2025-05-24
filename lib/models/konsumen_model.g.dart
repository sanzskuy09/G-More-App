// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'konsumen_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KonsumenModelAdapter extends TypeAdapter<KonsumenModel> {
  @override
  final int typeId = 0;

  @override
  KonsumenModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KonsumenModel(
      nik: fields[0] as String,
      nama: fields[1] as String,
      tempat: fields[2] as String,
      tglLahir: fields[3] as String,
      alamat: fields[4] as String,
      showRoom: fields[5] as String,
      catatan: fields[6] as String,
      status: fields[7] as String,
      fotoKtp: fields[8] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, KonsumenModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.nik)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.tempat)
      ..writeByte(3)
      ..write(obj.tglLahir)
      ..writeByte(4)
      ..write(obj.alamat)
      ..writeByte(5)
      ..write(obj.showRoom)
      ..writeByte(6)
      ..write(obj.catatan)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.fotoKtp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KonsumenModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
