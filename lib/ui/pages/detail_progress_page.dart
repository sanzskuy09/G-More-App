import 'package:flutter/material.dart';
import 'package:gmore/models/order_model.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/widgets/buttons.dart';
import 'package:gmore/ui/widgets/detail_status_slik.dart'; // Asumsi widget ini sudah ada
import 'dart:typed_data';

import 'package:intl/intl.dart'; // Diperlukan untuk Uint8List

// --- SALIN DAN GANTI SEMUA KODE DI FILE ANDA DENGAN INI ---

class DetailProgressPage extends StatelessWidget {
  final OrderModel order;

  const DetailProgressPage({super.key, required this.order});

  // Helper untuk memastikan string tidak null atau kosong
  String safeString(dynamic val) => val?.toString() ?? '';
  bool isNotEmpty(dynamic val) =>
      val != null && val.toString().trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Latar belakang abu-abu untuk kontras dengan Card putih
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Detail order')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // 2. Widget Header untuk Info Utama
          _buildHeaderCard(context),
          const SizedBox(height: 16),

          // 3. Card untuk Data Pribadi
          _buildSectionCard(
            title: 'Data Pribadi',
            children: [
              _buildInfoRow(Icons.person_outline, 'Nama', order.nama!),
              _buildInfoRow(Icons.credit_card_outlined, 'NIK', order.nik!),
              _buildInfoRow(Icons.wc_outlined, 'Jenis Kelamin',
                  order.jeniskelamin == 1 ? 'LAKI-LAKI' : 'PEREMPUAN'),
              _buildInfoRow(Icons.cake_outlined, 'Tmp/Tgl Lahir',
                  '${safeString(order.tempatlahir)}, ${order.tgllahir != null ? DateFormat('dd-MM-yyyy', 'id_ID').format(order.tgllahir!) : '-'}'),
              _buildInfoRow(Icons.calendar_today_outlined, 'Umur',
                  '${safeString(order.umur)} Tahun'),
              _buildInfoRow(
                  Icons.home_outlined, 'Alamat', _buildFullAddress(order)),
            ],
          ),
          const SizedBox(height: 16),

          // 4. Card untuk Data Pasangan (hanya muncul jika menikah)
          if (order.statusperkawinan!.toLowerCase() == 'menikah') ...[
            _buildSectionCard(
              isPartner: true,
              title: 'Data Pasangan',
              children: [
                _buildInfoRow(Icons.person_outline, 'Nama Pasangan',
                    safeString(order.namapasangan)),
                _buildInfoRow(Icons.credit_card_outlined, 'NIK Pasangan',
                    safeString(order.nikpasangan)),
                _buildInfoRow(
                  Icons.cake_outlined,
                  'Tmp/Tgl Lahir',
                  '${safeString(order.tempatlahirpasangan)}, ${order.tgllahirpasangan != null ? DateFormat('dd-MM-yyyy', 'id_ID').format(order.tgllahirpasangan!) : '-'}',
                ),
                _buildInfoRow(Icons.home_outlined, 'Alamat Pasangan',
                    _buildFullAddress(order, isPartner: true)),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // 5. Card untuk Info Lainnya
          _buildSectionCard(
            title: 'Informasi Lainnya',
            children: [
              _buildInfoRow(
                  Icons.store_outlined, 'Dealer', safeString(order.dealer)),
              _buildInfoRow(Icons.note_alt_outlined, 'Catatan',
                  safeString(order.catatan)),
              // Menggunakan widget status slik yang sudah ada
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: DetailStatusSlik(
                    label: 'Hasil Slik', status: order.statusslik!),
              ),
            ],
          ),
        ],
      ),
      // 6. Tombol Aksi di bagian bawah layar
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  // WIDGET BARU: Header Card
  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Foto dengan bentuk lingkaran
            CircleAvatar(
              radius: 35,
              backgroundColor: primaryColor.withOpacity(0.1),
              backgroundImage:
                  order.fotoktp != null ? MemoryImage(order.fotoktp!) : null,
              child: order.fotoktp == null
                  ? Icon(Icons.person, size: 40, color: primaryColor)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.nama ?? 'Nama Tidak Tersedia',
                    style:
                        blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: ${safeString(order.statusperkawinan)}',
                    style: greyTextStyle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sync Data : ${safeString(order.isSynced) == 'true' ? 'Sudah' : 'Belum'}',
                    style: greyTextStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET BARU: Section Card yang reusable
  Widget _buildSectionCard(
      {required String title,
      required List<Widget> children,
      bool isPartner = false}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(isPartner ? Icons.favorite_border : Icons.info_outline,
                    color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: blackTextStyle.copyWith(
                      fontSize: 16, fontWeight: semiBold),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  // WIDGET BARU: Row Info dengan Ikon
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: greyTextStyle.copyWith(fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  isNotEmpty(value) ? value : '-',
                  style:
                      blackTextStyle.copyWith(fontSize: 14, fontWeight: medium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET BARU: Bottom Action Buttons
  Widget _buildActionButtons(BuildContext context) {
    final String statusSlik = order.statusslik!.toUpperCase();
    final bool isButtonDisabled =
        statusSlik == 'PENDING' || statusSlik == 'REJECT';

    return Container(
      padding: const EdgeInsets.fromLTRB(
          16, 16, 16, 32), // Padding bawah lebih besar untuk safe area
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {/* Logika Reject */},
              style: OutlinedButton.styleFrom(
                  foregroundColor: redColor,
                  side: BorderSide(color: redColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Reject'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomFilledButton(
              title: "Lanjut Survey",
              color: isButtonDisabled ? greyColor : successColor,
              onPressed: isButtonDisabled
                  ? null
                  : () {
                      // Logika Lanjut Survey hanya berjalan jika tombol aktif
                      print('Tombol Lanjut Survey Ditekan!');
                    },
            ),
          ),
        ],
      ),
    );
  }

  // HELPER BARU: Menggabungkan alamat menjadi satu string yang rapi
  String _buildFullAddress(OrderModel data, {bool isPartner = false}) {
    final address = isPartner ? data.alamatpasangan : data.alamat;
    final rt = isPartner ? data.rtpasangan : data.rt;
    final rw = isPartner ? data.rwpasangan : data.rw;
    final kel = isPartner ? data.kelpasangan : data.kel;
    final kec = isPartner ? data.kecpasangan : data.kec;
    final kota = isPartner ? data.kotapasangan : data.kota;
    final prov = isPartner ? data.provinsipasangan : data.provinsi;
    final kodepos = isPartner ? data.kodepospasangan : data.kodepos;

    List<String> parts = [
      if (isNotEmpty(address)) safeString(address),
      if (isNotEmpty(rt) || isNotEmpty(rw))
        'RT ${safeString(rt)}/RW ${safeString(rw)}',
      if (isNotEmpty(kel)) 'Kel. ${safeString(kel)}',
      if (isNotEmpty(kec)) 'Kec. ${safeString(kec)}',
      if (isNotEmpty(kota)) safeString(kota),
      if (isNotEmpty(prov)) safeString(prov),
      if (isNotEmpty(kodepos)) safeString(kodepos),
    ];

    return parts.join(', ');
  }
}
