import 'package:flutter/material.dart';
import 'package:gmore/models/konsumen_model.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/pages/detail_progress_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  // void _konfirmasiHapus(
  //     BuildContext context, Box<KonsumenModel> box, int index) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Hapus Task'),
  //       content:
  //           const Text('Apakah Anda yakin ingin menghapus data konsumen ini?'),
  //       actions: [
  //         TextButton(
  //           child: const Text('Batal'),
  //           onPressed: () => Navigator.of(context).pop(), // tutup dialog
  //         ),
  //         TextButton(
  //           child: const Text('Hapus', style: TextStyle(color: Colors.red)),
  //           onPressed: () {
  //             box.deleteAt(index); // hapus data
  //             Navigator.of(context).pop(); // tutup dialog
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _tampilkanKonfirmasiBottomSheet(
      BuildContext context, Box box, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 48, color: Colors.red),
              const SizedBox(height: 12),
              const Text(
                'Hapus Task?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apakah Anda yakin ingin menghapus data konsumen ini?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      child: Text('Batal', style: blackTextStyle),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Hapus', style: whiteTextStyle),
                      onPressed: () {
                        box.deleteAt(index);
                        Navigator.pop(context); // tutup modal
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<KonsumenModel>('konsumen');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Konsumen'),
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<KonsumenModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Belum ada data konsumen.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final konsumen = box.getAt(index);
              if (konsumen == null) return const SizedBox();

              return ListTile(
                leading: konsumen.fotoKtp != null
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(konsumen.fotoKtp!),
                      )
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(konsumen.nama),
                subtitle:
                    Text('NIK: ${konsumen.nik}\nAlamat: ${konsumen.alamat}'),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // box.deleteAt(index);
                    // _konfirmasiHapus(context, box, index);
                    _tampilkanKonfirmasiBottomSheet(context, box, index);
                  },
                ),
                onTap: () {
                  // Bisa buka halaman detail jika mau
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailProgressPage(konsumen: konsumen),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       // Navigator.of(context).push(
      //       //   MaterialPageRoute(builder: (_) => const HomeDetailScreen()),
      //       // );
      //     },
      //     child: const Text('Go to Progress Detail'),
      //   ),
      // ),
    );
  }
}
