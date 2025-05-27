import 'package:flutter/material.dart';
import 'package:gmore/models/konsumen_model.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/widgets/buttons.dart';
import 'package:gmore/ui/widgets/detail_status_slik.dart';

class DetailProgressPage extends StatelessWidget {
  final KonsumenModel konsumen;

  const DetailProgressPage({super.key, required this.konsumen});

  String tampilkanAtauStrip(String? value) {
    return value?.trim().isNotEmpty == true ? value! : '-';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Konsumen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Data Pribadi',
                style: greyTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
            ),
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
            if (konsumen.statusPernikahan == 'Menikah')
              Column(
                children: [
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Data Pasangan',
                      style: greyTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                  Center(
                    child: konsumen.fotoKtpPasangan != null
                        ? Image.memory(
                            konsumen.fotoKtpPasangan!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.person, size: 100),
                  ),
                  const SizedBox(height: 16),
                  _buildDetail(
                      'NIK ', tampilkanAtauStrip(konsumen.nikPasangan)),
                  _buildDetail(
                      'Nama ', tampilkanAtauStrip(konsumen.namaPasangan)),
                  _buildDetail('Tempat Lahir ',
                      tampilkanAtauStrip(konsumen.tempatPasangan)),
                  _buildDetail('Tanggal Lahir ',
                      tampilkanAtauStrip(konsumen.tglLahirPasangan)),
                  _buildDetail(
                      'Alamat ', tampilkanAtauStrip(konsumen.alamatPasangan)),
                ],
              ),
            const Divider(),
            _buildDetail('Show Room', konsumen.showRoom),
            _buildDetail('Catatan', tampilkanAtauStrip(konsumen.catatan)),
            // _buildDetailStatus('Status', konsumen.status),
            DetailStatusSlik(label: 'Hasil Slik', status: konsumen.status),
            const Divider(),
            const SizedBox(height: 8),
            CustomFilledButton(
                title: "Lanjut Survey", color: successColor, onPressed: () {}),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {},
              child: Text(
                'Reject',
                style: TextStyle(color: Colors.red, fontWeight: semiBold),
              ),
            ),
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
