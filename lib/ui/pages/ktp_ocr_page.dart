import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmore/models/konsumen_model.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/widgets/buttons.dart';
import 'package:gmore/ui/widgets/ktp_camera.dart';
// import 'package:gmore/ui/widgets/ktp_camera_screen.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hive/hive.dart';

class KtpOcrPage extends StatefulWidget {
  const KtpOcrPage({super.key});

  @override
  State<KtpOcrPage> createState() => _KtpOcrPageState();
}

class _KtpOcrPageState extends State<KtpOcrPage> {
  File? _image;
  String _extractedText = '';
  bool _loading = false;
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
    // final picker = ImagePicker();
    // final picked = await picker.pickImage(source: ImageSource.camera);

    // if (picked != null) {
    //   setState(() {
    //     _image = File(picked.path);
    //     _loading = true;
    //   });
    //   _scanText(File(picked.path));
    // }
    final File? img = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KtpCamera()),
    );
    if (img != null) {
      _image = img;
      await _scanText(img); // lanjut proses OCR
    }
  }

  Future<void> _scanText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizer = TextRecognizer();
    final result = await recognizer.processImage(inputImage);
    recognizer.close();

    final parsed = parseKtpFields(result.text);

    print('INI ADALAH HASIL DARI SCAN');
    print(result);

    setState(() {
      _extractedText = result.text;
      _loading = false;
      _controllers['nik']!.text = parsed['nik'] ?? '';
      _controllers['nama']!.text = parsed['nama'] ?? '';
      _controllers['tempat']!.text = parsed['tempat'] ?? '';
      _controllers['tgl_lahir']!.text = parsed['tgl_lahir'] ?? '';
      _controllers['alamat']!.text = parsed['alamat'] ?? '';
    });
  }

  // Map<String, String> parseKtpFields(String rawText) {
  //   final lines = rawText.split('\n');

  //   String getLineContaining(String keyword) {
  //     return lines.firstWhere(
  //       (l) => l.toUpperCase().contains(keyword),
  //       orElse: () => '',
  //     );
  //   }

  //   String? extractTanggal(String text) {
  //     final match = RegExp(r'\d{2}-\d{2}-\d{4}').firstMatch(text);
  //     return match?.group(0) ?? '';
  //   }

  //   String tempat = '';
  //   String tglLahir = '';

  //   final tempatTgl = getLineContaining('TEMPAT');
  //   if (tempatTgl.isNotEmpty) {
  //     final split = tempatTgl.split(':');
  //     if (split.length > 1) {
  //       final val = split[1].trim();
  //       final parts = val.split(',');
  //       if (parts.length == 2) {
  //         tempat = parts[0].trim();
  //         tglLahir = parts[1].trim();
  //       } else {
  //         tempat = val;
  //       }
  //     }
  //   }

  //   return {
  //     'nik': getLineContaining('NIK').split(':').last.trim(),
  //     'nama': getLineContaining('NAMA').split(':').last.trim(),
  //     'tempat': tempat,
  //     'tgl_lahir': tglLahir,
  //     'alamat': getLineContaining('ALAMAT').split(':').last.trim(),
  //   };
  // }

  // Map<String, String> parseKtpFields(String rawText) {
  //   final lines = rawText.toUpperCase().split('\n');
  //   String getNextLineValue(String key) {
  //     for (int i = 0; i < lines.length; i++) {
  //       if (lines[i].contains(key)) {
  //         // Ambil isi di baris ini (jika ada) atau baris berikutnya
  //         final current = lines[i].replaceAll(key, '').trim();
  //         if (current.isNotEmpty) return current;
  //         if (i + 1 < lines.length) return lines[i + 1].trim();
  //       }
  //     }
  //     return '';
  //   }

  //   String tempat = '';
  //   String tgl = '';
  //   final tempatTgl = getNextLineValue('TEMPAT');
  //   if (tempatTgl.contains(',')) {
  //     final parts = tempatTgl.split(',');
  //     tempat = parts[0].trim();
  //     tgl = parts[1].trim();
  //   } else {
  //     tempat = tempatTgl;
  //     final tglRaw = getNextLineValue('LAHIR');
  //     tgl =
  //         RegExp(r'\d{2}[-/]\d{2}[-/]\d{4}').firstMatch(tglRaw)?.group(0) ?? '';
  //   }

  //   return {
  //     'nik': getNextLineValue('NIK'),
  //     'nama': getNextLineValue('NAMA'),
  //     'tempat': tempat,
  //     'tgl_lahir': tgl,
  //     'alamat': getNextLineValue('ALAMAT'),
  //   };
  // }

  Map<String, String> parseKtpFields(String ocrText) {
    final lines = ocrText.split('\n');

    String nik = '';
    String nama = '';
    String tempatLahir = '';
    String tglLahir = '';
    String alamat = '';

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Deteksi NIK (16 digit)
      if (nik.isEmpty &&
          RegExp(r'\b[\dA-Z]{12,18}\b', caseSensitive: false).hasMatch(line)) {
        nik = line;
      }

      // Deteksi Nama (huruf kapital, tanpa angka, mungkin ada ":" di awal)
      else if (nama.isEmpty) {
        // Hilangkan karakter ":" dan trim
        final normalized = line.replaceAll(':', '').trim();

        // Cek jika hanya huruf besar dan spasi, tanpa angka
        if (RegExp(r'^[A-Z\s]+$').hasMatch(normalized) &&
            !normalized.contains(RegExp(r'\d')) &&
            !normalized.contains('NIK') &&
            !normalized.contains('KOTA') &&
            (!normalized.contains('PRO') || !normalized.contains('VINSI'))) {
          nama = normalized;
        }
      }

      // Deteksi Tempat/Tgl Lahir (dengan koma dan format tanggal)
      else if (tempatLahir.isEmpty &&
          (line.contains(',') || line.contains(RegExp(r'\d{2}-\d{2}-\d{4}')))) {
        // Kasus 1: Format "JAKARTA, 09-03-2000"
        if (line.contains(',')) {
          final parts = line.split(',');
          if (parts.length == 2) {
            tempatLahir = parts[0].trim();
            tglLahir = parts[1].trim();
          }
        }

        // Kasus 2: Format "JAKARTA 09-03-2000" atau "JAKARTA 09-032000"
        else {
          final match =
              RegExp(r'(.*?)(\d{2}-\d{2}-\d{4}|\d{2}-\d{6})').firstMatch(line);
          if (match != null) {
            tempatLahir = match.group(1)?.trim() ?? '';
            tglLahir = match.group(2)?.trim() ?? '';
          }
        }
      }

      // Deteksi Alamat
      else if (alamat.isEmpty &&
          (line.toLowerCase().contains('jl') ||
              line.toLowerCase().contains('jalan') ||
              line.toLowerCase().contains('gg') ||
              line.toLowerCase().contains('kp'))) {
        alamat = line;
      }
    }

    return {
      'nik': nik,
      'nama': nama,
      'tempat_lahir': tempatLahir,
      'tgl_lahir': tglLahir,
      'alamat': alamat,
    };
  }

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
    );

    final box = Hive.box<KonsumenModel>('konsumen');
    await box.add(konsumen);

    // Clear form kalau mau
    _controllers.forEach((key, controller) => controller.clear());

    if (!context.mounted) return; // ✅ aman
    Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
    // Navigator.pushNamed(context, '/main');
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
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: primaryColor),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor, // warna saat focus
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Form')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
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
            if (_image != null) Image.file(_image!, height: 200),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildField('NIK', 'nik'),
                  buildField('Nama', 'nama'),
                  buildField('Tempat Lahir', 'tempat'),
                  buildField('Tanggal Lahir', 'tgl_lahir'),
                  buildField('Alamat', 'alamat'),
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
            // SizedBox(height: 20),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Text(
            //       _extractedText,
            //       style: TextStyle(fontSize: 16),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
