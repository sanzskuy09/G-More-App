import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmore/models/konsumen_model.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/widgets/buttons.dart';
import 'package:gmore/ui/widgets/ktp2_camera.dart';
import 'package:gmore/ui/widgets/upload_foto.dart';
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
    'jeniskelamin': TextEditingController(),
    'alamat': TextEditingController(),
    'rt': TextEditingController(),
    'rw': TextEditingController(),
    'kel': TextEditingController(),
    'kec': TextEditingController(),
    'kota': TextEditingController(),
    'provinsi': TextEditingController(),
    'dealer': TextEditingController(),
    'catatan': TextEditingController(),
  };

  Future<void> _pickImage() async {
    final File? img = await Navigator.push(
      context,
      // MaterialPageRoute(builder: (_) => KtpCamera()),
      // MaterialPageRoute(builder: (_) => Ktp2Camera()),
      MaterialPageRoute(builder: (_) => UploadFoto()),
    );
    if (img != null) {
      setState(() {
        _image = img;
      });
      // _image = img;
      // await _scanText(img); // lanjut proses OCR
    }
  }

  Future<void> _scanText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizer = TextRecognizer();
    final result = await recognizer.processImage(inputImage);
    recognizer.close();

    final parsed = parseKtpFields(result.text);
    // print(parsed);
    // print('==========================');
    // print(result.text);

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
    'jeniskelamin': TextEditingController(),
    'alamat': TextEditingController(),
    'rt': TextEditingController(),
    'rw': TextEditingController(),
    'kel': TextEditingController(),
    'kec': TextEditingController(),
    'kota': TextEditingController(),
    'provinsi': TextEditingController(),
  };

  String _statusPernikahan = 'Belum Menikah';
  String? _namaCabang;
  String? _jeniskelamin;
  List<String> listCabang = ['Depok', 'Jakarta'];
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

  void _submitForm(BuildContext context) async {
    final konsumen = KonsumenModel(
      nik: _controllers['nik']!.text,
      nama: _controllers['nama']!.text,
      tempat: _controllers['tempat']!.text,
      tglLahir: _controllers['tgl_lahir']!.text,
      alamat: _controllers['alamat']!.text,
      showRoom: _controllers['dealer']!.text,
      catatan: _controllers['catatan']!.text,
      status: 'pending',
      statusPernikahan: _statusPernikahan,
      // namaCabang: _namaCabang,
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
    // Dropdown khusus untuk Jenis Kelamin
    if (key == 'jeniskelamin') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DropdownButtonFormField2<String>(
          value:
              _controllers[key]!.text.isEmpty ? null : _controllers[key]!.text,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.grey.shade100,
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
            padding: EdgeInsets.zero,
            offset: const Offset(0, 0),
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8, left: 0),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
          items: ['-- Pilih Jenis Kelamin --', 'LAKI-LAKI', 'PEREMPUAN']
              .map((status) {
            return DropdownMenuItem(
              value: status == '-- Pilih Jenis Kelamin --' ? null : status,
              child: Text(status),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _controllers[key]!.text = value ?? '';
            });
          },
        ),
      );
    }

    // Default: TextFormField
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        textCapitalization: TextCapitalization.characters,
        keyboardType: key == 'nik' ||
                key == 'rt' ||
                key == 'rw' ||
                key == 'umur' ||
                key == 'kodepos'
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: key == 'nik'
            ? [
                LengthLimitingTextInputFormatter(16),
                FilteringTextInputFormatter.digitsOnly,
              ]
            : null,
        controller: _controllers[key],
        readOnly: key == 'tgl_lahir',
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
        validator: key == 'nik'
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Nik Wajib Di isi';
                }
                if (value.length != 16) {
                  return 'Nik Tidak Valid';
                }
                return null;
              }
            : null,
      ),
    );
  }

  // Widget buildField(String label, String key) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: TextFormField(
  //       textCapitalization: TextCapitalization.characters,
  //       keyboardType: key == 'nik' ||
  //               key == 'rt' ||
  //               key == 'rw' ||
  //               key == 'umur' ||
  //               key == 'kodepos'
  //           ? TextInputType.number
  //           : TextInputType.text,
  //       inputFormatters: key == 'nik'
  //           ? [
  //               LengthLimitingTextInputFormatter(16),
  //               FilteringTextInputFormatter(RegExp('[0-9]'), allow: true)
  //             ]
  //           : null,
  //       controller: _controllers[key],
  //       readOnly: key == 'tgl_lahir', // hanya readonly jika tgl lahir
  //       onTap: key == 'tgl_lahir'
  //           ? () async {
  //               DateTime? pickedDate = await showDatePicker(
  //                 context: context,
  //                 initialDate: DateTime.now(),
  //                 firstDate: DateTime(1900),
  //                 lastDate: DateTime.now(),
  //               );
  //               if (pickedDate != null) {
  //                 final formattedDate =
  //                     "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
  //                 _controllers[key]!.text = formattedDate;
  //               }
  //             }
  //           : null,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         labelStyle: TextStyle(color: blackColor),
  //         border: const OutlineInputBorder(),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: primaryColor,
  //             width: 2,
  //           ),
  //         ),
  //         suffixIcon:
  //             key == 'tgl_lahir' ? const Icon(Icons.calendar_today) : null,
  //       ),
  //       validator: key == 'nik'
  //           ? (value) {
  //               if (value == null || value.isEmpty) {
  //                 return 'Nik Wajib Di isi';
  //               }

  //               if (value.length != 16) {
  //                 return 'Nik Tidak Valid';
  //               }

  //               return null;
  //             }
  //           : null,
  //     ),
  //   );
  // }

  Widget buildSpouseField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        textCapitalization: TextCapitalization.characters,
        keyboardType: key == 'nik' ||
                key == 'rt' ||
                key == 'rw' ||
                key == 'umur' ||
                key == 'kodepos'
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: key == 'nik'
            ? [
                LengthLimitingTextInputFormatter(16),
                FilteringTextInputFormatter(RegExp('[0-9]'), allow: true)
              ]
            : null,
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
      appBar: AppBar(title: Text('FORM ORDER')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            DropdownButtonFormField2<String>(
              value: _namaCabang,
              isExpanded: true,
              decoration: InputDecoration(
                // contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                labelText: 'Nama Cabang',
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
              items: ['-- Pilih Cabang --', 'Depok', 'Jakarta'].map((status) {
                return DropdownMenuItem(
                  value: status == '-- Pilih Cabang --' ? null : status,
                  child: Row(
                    children: [
                      Text(status),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _namaCabang = value!;
                });
              },
            ),

            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),

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
              items: ['Menikah', 'Belum Menikah', 'Janda/Duda'].map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Row(
                    children: [
                      Icon(
                        status == 'Menikah'
                            ? Icons.group
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
                'KTP PEMOHON',
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
                    "Unggah Foto KTP",
                    style: whiteTextStyle.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            if (_loading) CircularProgressIndicator(),
            const SizedBox(height: 10),
            if (_image != null) Image.file(_image!),
            SizedBox(height: 10),
            buildField('Jenis Kelamin', 'jeniskelamin'),
            buildField('Nama', 'nama'),
            buildField('NIK', 'nik'),
            buildField('Umur', 'umur'),
            buildField('Tempat Lahir', 'tempat'),
            buildField('Tanggal Lahir', 'tgl_lahir'),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: primaryColor, width: 2), // 🟥 Border merah
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔺 Header Merah
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      // borderRadius: BorderRadius.vertical(
                      //   top: Radius.circular(5),
                      // ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.maps_home_work, color: whiteColor),
                        SizedBox(width: 12),
                        Text(
                          'Alamat KTP',
                          style: whiteTextStyle.copyWith(
                              fontSize: 16, fontWeight: semiBold),
                        ),
                      ],
                    ),
                  ),
                  // ⬜ Konten Form Putih
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        buildField('Alamat', 'alamat'),
                        Row(
                          children: [
                            Expanded(
                              child: buildField('RT', 'rt'),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '/',
                              style: blackTextStyle.copyWith(fontSize: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: buildField('RW', 'rw'),
                            )
                          ],
                        ),
                        buildField('Kelurahan/Desa', 'kel'),
                        buildField('Kecamatan', 'kec'),
                        buildField('Kota', 'kota'),
                        buildField('Provinsi', 'provinsi'),
                        buildField('Kode Pos', 'kodepos'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Upload KTP PRIBADI END
            // ================================
            // Upload KTP PASANGAN (SPOUSE) START
            if (_statusPernikahan == 'Menikah') ...[
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
                      "Unggah Foto KTP Pasangan",
                      style: whiteTextStyle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (_spouseImage != null) Image.file(_spouseImage!, height: 200),
              const SizedBox(height: 10),
              buildSpouseField('Nama', 'nama'),
              buildSpouseField('NIK', 'nik'),
              buildSpouseField('Umur', 'umur'),
              buildSpouseField('Tempat Lahir', 'tempat'),
              buildSpouseField('Tanggal Lahir', 'tgl_lahir'),
              // buildSpouseField('Alamat Pasangan', 'alamat'),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: primaryColor, width: 2), // 🟥 Border merah
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔺 Header Merah
                    Container(
                      decoration: BoxDecoration(color: primaryColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.maps_home_work, color: whiteColor),
                          SizedBox(width: 12),
                          Text(
                            'Alamat KTP Pasangan',
                            style: whiteTextStyle.copyWith(
                                fontSize: 16, fontWeight: semiBold),
                          ),
                        ],
                      ),
                    ),
                    // ⬜ Konten Form Putih
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          buildSpouseField('Alamat', 'alamat'),
                          Row(
                            children: [
                              Expanded(
                                child: buildSpouseField('RT', 'rt'),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '/',
                                style: blackTextStyle.copyWith(fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: buildSpouseField('RW', 'rw'),
                              )
                            ],
                          ),
                          buildSpouseField('Kelurahan/Desa', 'kel'),
                          buildSpouseField('Kecamatan', 'kec'),
                          buildSpouseField('Kota', 'kota'),
                          buildSpouseField('Provinsi', 'provinsi'),
                          buildSpouseField('Kode Pos', 'kodepos'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Upload KTP PASANGAN (SPOUSE) END
            const Divider(),
            const SizedBox(height: 10),

            buildField('Nama Dealer', 'dealer'),
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
