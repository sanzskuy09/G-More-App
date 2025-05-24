import 'package:flutter/material.dart';
import 'package:gmore/models/konsumen_model.dart';

class DetailProgressPage extends StatelessWidget {
  final KonsumenModel konsumen;

  const DetailProgressPage({super.key, required this.konsumen});

  String tampilkanAtauStrip(String? value) {
    return value?.trim().isNotEmpty == true ? value! : '-';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: konsumen.fotoKtp != null
                  ? Image.memory(
                      konsumen.fotoKtp!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person, size: 100),
            ),
            const SizedBox(height: 16),
            _buildDetail('NIK', konsumen.nik),
            _buildDetail('Nama', konsumen.nama),
            _buildDetail('Tempat Lahir', konsumen.tempat),
            _buildDetail('Tanggal Lahir', konsumen.tglLahir),
            _buildDetail('Alamat', konsumen.alamat),
            _buildDetail('Show Room', konsumen.showRoom),
            _buildDetail('Catatan', tampilkanAtauStrip(konsumen.catatan)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
