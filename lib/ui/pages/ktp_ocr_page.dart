import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmore/models/konsumen_model.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/widgets/buttons.dart';
import 'package:gmore/ui/widgets/ktp2_camera.dart';
import 'package:gmore/ui/widgets/ktp_camera.dart';
import 'package:gmore/utils/ktp_parser.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hive/hive.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class KtpOcrPage extends StatefulWidget {
  const KtpOcrPage({super.key});

  @override
  State<KtpOcrPage> createState() => _KtpOcrPageState();
}

class _KtpOcrPageState extends State<KtpOcrPage> {
  File? _image;
  bool _loading = false;
  String _extractedText = '';

  final Map<String, TextEditingController> _controllers = {
    'nik': TextEditingController(),
    'nama': TextEditingController(),
    'tempat': TextEditingController(),
    'tgl_lahir': TextEditingController(),
    'alamat': TextEditingController(),
    'show_room': TextEditingController(),
    'catatan': TextEditingController(),
  };

  Future<void> _pickImage() async {
    final File? img = await Navigator.push(
      context,
      // MaterialPageRoute(builder: (_) => KtpCamera()),
      MaterialPageRoute(builder: (_) => Ktp2Camera()),
    );
    if (img != null) {
      setState(() {
        _image = img;
      });
      // _image = img;
      await _scanText(img); // lanjut proses OCR
    }
  }

  Future<void> _scanText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizer = TextRecognizer();
    final result = await recognizer.processImage(inputImage);
    recognizer.close();

    final parsed = parseKtpFields(result.text);
    print(parsed);
    print('==========================');
    print(result.text);

    final alamat = parsed['alamat'] ?? '';
    final rtRw = parsed['rt_rw'] ?? '';

    setState(() {
      // _extractedText = result.text;
      _loading = false;
      _controllers['nik']!.text = parsed['nik'] ?? '';
      _controllers['nama']!.text = parsed['nama'] ?? '';
      _controllers['tempat']!.text = parsed['tempat_lahir'] ?? '';
      _controllers['tgl_lahir']!.text = parsed['tgl_lahir'] ?? '';
      _controllers['alamat']!.text =
          rtRw.isNotEmpty ? '$alamat RT/RW $rtRw' : alamat;
    });
  }

  // Handle Upload KTP SPOUSE
  final Map<String, TextEditingController> _spouseControllers = {
    'nik': TextEditingController(),
    'nama': TextEditingController(),
    'tempat': TextEditingController(),
    'tgl_lahir': TextEditingController(),
    'alamat': TextEditingController(),
  };

  String _statusPernikahan = 'Belum Menikah';
  File? _spouseImage;
  String _spouseExtractedText = '';

  Future<void> _pickSpouseImage() async {
    final File? img = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Ktp2Camera()),
    );
    if (img != null) {
      setState(() {
        _spouseImage = img;
      });
      // _spouseImage = img;
      await _scanSpouseText(img);
    }
  }

  Future<void> _scanSpouseText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizer = TextRecognizer();
    final result = await recognizer.processImage(inputImage);
    recognizer.close();

    // final parsed = parseKtpFields(result.text);
    final parsed = parseKtpFields(result.text);

    setState(() {
      // _spouseExtractedText = result.text;
      _spouseControllers['nik']!.text = parsed['nik'] ?? '';
      _spouseControllers['nama']!.text = parsed['nama'] ?? '';
      _spouseControllers['tempat']!.text = parsed['tempat'] ?? '';
      _spouseControllers['tgl_lahir']!.text = parsed['tgl_lahir'] ?? '';
      _spouseControllers['alamat']!.text = parsed['alamat'] ?? '';
    });
  }

  // Map<String, String> parseKtpFields(String ocrText) {
  //   final lines = ocrText.split('\n');

  //   String nik = '';
  //   String nama = '';
  //   String tempatLahir = '';
  //   String tglLahir = '';
  //   String alamat = '';

  //   for (int i = 0; i < lines.length; i++) {
  //     final line = lines[i].trim();

  //     // Deteksi NIK (16 digit)
  //     if (nik.isEmpty &&
  //         RegExp(r'\b[\dA-Z]{12,18}\b', caseSensitive: false).hasMatch(line)) {
  //       nik = line;
  //     }

  //     // Deteksi Nama (huruf kapital, tanpa angka, mungkin ada ":" di awal)
  //     else if (nama.isEmpty) {
  //       // Hilangkan karakter ":" dan trim
  //       final normalized = line.replaceAll(':', '').trim();

  //       // Cek jika hanya huruf besar dan spasi, tanpa angka
  //       if (RegExp(r'^[A-Z\s]+$').hasMatch(normalized) &&
  //           !normalized.contains(RegExp(r'\d')) &&
  //           !normalized.contains('NIK') &&
  //           !normalized.contains('KOTA') &&
  //           (!normalized.contains('PRO') || !normalized.contains('VINSI'))) {
  //         nama = normalized;
  //       }
  //     }

  //     // Deteksi Tempat/Tgl Lahir (dengan koma dan format tanggal)
  //     else if (tempatLahir.isEmpty &&
  //         (line.contains(',') || line.contains(RegExp(r'\d{2}-\d{2}-\d{4}')))) {
  //       // Kasus 1: Format "JAKARTA, 09-03-2000"
  //       if (line.contains(',')) {
  //         final parts = line.split(',');
  //         if (parts.length == 2) {
  //           tempatLahir = parts[0].trim();
  //           tglLahir = parts[1].trim();
  //         }
  //       }

  //       // Kasus 2: Format "JAKARTA 09-03-2000" atau "JAKARTA 09-032000"
  //       else {
  //         final match =
  //             RegExp(r'(.*?)(\d{2}-\d{2}-\d{4}|\d{2}-\d{6})').firstMatch(line);
  //         if (match != null) {
  //           tempatLahir = match.group(1)?.trim() ?? '';
  //           tglLahir = match.group(2)?.trim() ?? '';
  //         }
  //       }
  //     }

  //     // Deteksi Alamat
  //     else if (alamat.isEmpty &&
  //         (line.toLowerCase().contains('jl') ||
  //             line.toLowerCase().contains('jalan') ||
  //             line.toLowerCase().contains('gg') ||
  //             line.toLowerCase().contains('kp'))) {
  //       alamat = line;
  //     }
  //   }

  //   return {
  //     'nik': nik,
  //     'nama': nama,
  //     'tempat_lahir': tempatLahir,
  //     'tgl_lahir': tglLahir,
  //     'alamat': alamat,
  //   };
  // }

  void _submitForm(BuildContext context) async {
    final konsumen = KonsumenModel(
      nik: _controllers['nik']!.text,
      nama: _controllers['nama']!.text,
      tempat: _controllers['tempat']!.text,
      tglLahir: _controllers['tgl_lahir']!.text,
      alamat: _controllers['alamat']!.text,
      showRoom: _controllers['show_room']!.text,
      catatan: _controllers['catatan']!.text,
      status: 'pending',
      statusPernikahan: _statusPernikahan,
      // field pasangan
      nikPasangan: _statusPernikahan == 'Menikah'
          ? _spouseControllers['nik']?.text
          : null,
      namaPasangan: _statusPernikahan == 'Menikah'
          ? _spouseControllers['nama']?.text
          : null,
      tempatPasangan: _statusPernikahan == 'Menikah'
          ? _spouseControllers['tempat']?.text
          : null,
      tglLahirPasangan: _statusPernikahan == 'Menikah'
          ? _spouseControllers['tgl_lahir']?.text
          : null,
      alamatPasangan: _statusPernikahan == 'Menikah'
          ? _spouseControllers['alamat']?.text
          : null,
    );

    final box = Hive.box<KonsumenModel>('konsumen');
    await box.add(konsumen);

    // Clear form kalau mau
    _controllers.forEach((key, controller) => controller.clear());

    if (!context.mounted) return; // ✅ aman
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/daftar-konsumen',
      (_) => false,
    );
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget buildField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: _controllers[key],
        readOnly: key == 'tgl_lahir', // hanya readonly jika tgl lahir
        onTap: key == 'tgl_lahir'
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  final formattedDate =
                      "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                  _controllers[key]!.text = formattedDate;
                }
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: blackColor),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              width: 2,
            ),
          ),
          suffixIcon:
              key == 'tgl_lahir' ? const Icon(Icons.calendar_today) : null,
        ),
      ),
    );
  }

  Widget buildSpouseField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: _spouseControllers[key],
        readOnly: key == 'tgl_lahir', // hanya readonly jika tgl lahir
        onTap: key == 'tgl_lahir'
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  final formattedDate =
                      "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                  _spouseControllers[key]!.text = formattedDate;
                }
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: blackColor),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              width: 2,
            ),
          ),
          suffixIcon:
              key == 'tgl_lahir' ? const Icon(Icons.calendar_today) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Form')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            // DropdownButtonFormField<String>(
            //   value: _statusPernikahan,
            //   decoration: InputDecoration(
            //     labelText: 'Status Pernikahan',
            //     border: const OutlineInputBorder(),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: BorderSide(
            //         color: primaryColor,
            //         width: 2,
            //       ),
            //     ),
            //   ),
            //   items: ['Belum Menikah', 'Menikah'].map((status) {
            //     return DropdownMenuItem(
            //       value: status,
            //       child: Text(status),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       _statusPernikahan = value!;
            //     });
            //   },
            // ),
            // DropdownButtonFormField<String>(
            //   value: _statusPernikahan,
            //   decoration: InputDecoration(
            //     labelText: 'Status Pernikahan',
            //     prefixIcon: const Icon(Icons.favorite, color: Colors.redAccent),
            //     filled: true,
            //     fillColor: Colors.grey.shade100,
            //     labelStyle: TextStyle(
            //       color: primaryColor,
            //       fontWeight: FontWeight.w600,
            //     ),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //         color: primaryColor,
            //         width: 2,
            //       ),
            //     ),
            //   ),
            //   dropdownColor: Colors.white,
            //   borderRadius: BorderRadius.circular(12),
            //   icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
            //   style: const TextStyle(
            //     color: Colors.black87,
            //     fontSize: 16,
            //   ),
            //   items: ['Belum Menikah', 'Menikah'].map((status) {
            //     return DropdownMenuItem(
            //       value: status,
            //       child: Row(
            //         children: [
            //           Icon(
            //             status == 'Menikah'
            //                 ? Icons.check_circle
            //                 : Icons.person_outline,
            //             color: status == 'Menikah' ? Colors.green : Colors.grey,
            //           ),
            //           const SizedBox(width: 10),
            //           Text(status),
            //         ],
            //       ),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       _statusPernikahan = value!;
            //     });
            //   },
            // ),

            DropdownButtonFormField2<String>(
              value: _statusPernikahan,
              isExpanded: true,
              decoration: InputDecoration(
                // contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                labelText: 'Status Pernikahan',
                // prefixIcon: const Icon(Icons.favorite, color: Colors.redAccent),
                filled: true,
                fillColor: Colors.grey.shade100,
                labelStyle: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 2,
                  ),
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                padding: EdgeInsets.zero, // padding dalam dropdown
                offset: Offset(0, 0), // posisi dropdown tepat di bawah
              ),
              buttonStyleData: ButtonStyleData(
                padding: const EdgeInsets.only(right: 8, left: 0),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
              items: ['Belum Menikah', 'Menikah'].map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Icon(
                        status == 'Menikah'
                            ? Icons.check_circle
                            : Icons.person_outline,
                        color: status == 'Menikah' ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(status),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _statusPernikahan = value!;
                });
              },
            ),

            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),

            // Upload KTP PRIBADI START
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'KTP PRIBADI',
                style: greyTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: whiteColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Upload KTP",
                    style: whiteTextStyle.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            if (_loading) CircularProgressIndicator(),
            if (_image != null) Image.file(_image!),

            SizedBox(height: 10),
            buildField('NIK', 'nik'),
            buildField('Nama', 'nama'),
            buildField('Tempat Lahir', 'tempat'),
            buildField('Tanggal Lahir', 'tgl_lahir'),
            buildField('Alamat', 'alamat'),
            // Upload KTP PRIBADI END
            // ================================
            // Upload KTP PASANGAN (SPOUSE) START
            if (_statusPernikahan == 'Menikah') ...[
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'KTP PASANGAN',
                  style: greyTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickSpouseImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, color: whiteColor),
                    SizedBox(width: 8),
                    Text(
                      "Upload KTP Pasangan",
                      style: whiteTextStyle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              if (_spouseImage != null) Image.file(_spouseImage!, height: 200),
              const SizedBox(height: 10),
              buildSpouseField('NIK Pasangan', 'nik'),
              buildSpouseField('Nama Pasangan', 'nama'),
              buildSpouseField('Tempat Lahir Pasangan', 'tempat'),
              buildSpouseField('Tanggal Lahir Pasangan', 'tgl_lahir'),
              buildSpouseField('Alamat Pasangan', 'alamat'),
            ],
            // Upload KTP PASANGAN (SPOUSE) END
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),

            buildField('Show Room', 'show_room'),
            buildField('Catatan', 'catatan'),
            const SizedBox(height: 30),
            CustomFilledButton(
              title: 'Submit',
              onPressed: () => _submitForm(context),
            ),
          ],
        ),
      ),
    );
  }
}
