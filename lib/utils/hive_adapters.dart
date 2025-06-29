import 'package:hive/hive.dart';

// Adapter ini memberitahu Hive cara menulis & membaca object DateTime
class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final int typeId = 100; // Gunakan typeId yang unik & belum terpakai

  @override
  DateTime read(BinaryReader reader) {
    // Saat membaca dari Hive: ubah integer (timestamp) kembali ke DateTime
    final millis = reader.readInt();
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    // Saat menulis ke Hive: ubah DateTime menjadi integer (timestamp)
    writer.writeInt(obj.millisecondsSinceEpoch);
  }
}
