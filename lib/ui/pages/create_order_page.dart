import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmore/models/order_model.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/widgets/buttons.dart';
import 'package:gmore/ui/widgets/field_builder.dart';
import 'package:gmore/ui/widgets/ktp2_camera.dart';
import 'package:gmore/ui/widgets/upload_foto.dart';
import 'package:gmore/utils/field_validator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hive/hive.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  bool _loading = false;

  String _statusPernikahan = 'Belum Menikah';
  String? _namaCabang;
  File? _spouseImage;

  final Map<String, TextEditingController> _controllers = {
    'cabang': TextEditingController(),
    'statuspernikahan': TextEditingController(),
    // field pemohon
    'umur': TextEditingController(),
    'nik': TextEditingController(),
    'nama': TextEditingController(),
    'tempatlahir': TextEditingController(),
    'tgllahir': TextEditingController(),
    'jeniskelamin': TextEditingController(),
    'alamat': TextEditingController(),
    'rt': TextEditingController(),
    'rw': TextEditingController(),
    'kel': TextEditingController(),
    'kec': TextEditingController(),
    'kota': TextEditingController(),
    'provinsi': TextEditingController(),
    'kodepos': TextEditingController(),
    // field pasangan
    'nikpasangan': TextEditingController(),
    'namapasangan': TextEditingController(),
    'tempatlahirpasangan': TextEditingController(),
    'tgllahirpasangan': TextEditingController(),
    'jeniskelaminpasangan': TextEditingController(),
    'alamatpasangan': TextEditingController(),
    'rtpasangan': TextEditingController(),
    'rwpasangan': TextEditingController(),
    'kelpasangan': TextEditingController(),
    'kecpasangan': TextEditingController(),
    'kotapasangan': TextEditingController(),
    'provinsipasangan': TextEditingController(),
    'kodepospasangan': TextEditingController(),
    // dealer
    'dealer': TextEditingController(),
    'catatan': TextEditingController(),
  };

  Future<void> _pickImage() async {
    final File? img = await Navigator.push(
      context,
      // MaterialPageRoute(builder: (_) => Ktp2Camera()),
      MaterialPageRoute(builder: (_) => UploadFoto()),
    );
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  Future<void> _pickSpouseImage() async {
    final File? img = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Ktp2Camera()),
    );
    if (img != null) {
      setState(() {
        _spouseImage = img;
      });
    }
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Konversi nilai form ke JSON Map
      final formData =
          _controllers.map((key, controller) => MapEntry(key, controller.text));

      // Tampilkan alert dialog dengan JSON
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Data Form (Preview JSON)'),
          content: SingleChildScrollView(
            child: SelectableText(
              const JsonEncoder.withIndent('  ').convert(formData),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Kirim ke backend di sini
                print('Mengirim ke backend: $formData');

                // final order = OrderModel(
                //   statusslik: 'REJECT',
                //   cabang: _controllers['cabang']!.text,
                //   statusperkawinan: _controllers['statuspernikahan']!.text,
                //   jeniskelamin: int.parse(_controllers['jeniskelamin']!.text),
                //   umur: _controllers['umur']!.text,
                //   nama: _controllers['nama']!.text,
                //   nik: _controllers['nik']!.text,
                //   tempatlahir: _controllers['tempatlahir']!.text,
                //   tgllahir: _controllers['tgllahir']!.text,
                //   alamat: _controllers['alamat']!.text,
                //   rt: _controllers['rt']!.text,
                //   rw: _controllers['rw']!.text,
                //   kel: _controllers['kel']!.text,
                //   kec: _controllers['kec']!.text,
                //   kota: _controllers['kota']!.text,
                //   provinsi: _controllers['provinsi']!.text,
                //   kodepos: _controllers['kodepos']!.text,
                //   // pasangan
                //   namapasangan: _controllers['namapasangan']!.text,
                //   nikpasangan: _controllers['nikpasangan']!.text,
                //   tempatlahirpasangan:
                //       _controllers['tempatlahirpasangan']!.text,
                //   tgllahirpasangan: _controllers['tgllahirpasangan']!.text,
                //   alamatpasangan: _controllers['alamatpasangan']!.text,
                //   rtpasangan: _controllers['rtpasangan']!.text,
                //   rwpasangan: _controllers['rwpasangan']!.text,
                //   kelpasangan: _controllers['kelpasangan']!.text,
                //   kecpasangan: _controllers['kecpasangan']!.text,
                //   kotapasangan: _controllers['kotapasangan']!.text,
                //   provinsipasangan: _controllers['provinsipasangan']!.text,
                //   kodepospasangan: _controllers['kodepospasangan']!.text,
                //   // delaer
                //   dealer: _controllers['dealer']!.text,
                //   catatan: _controllers['catatan']!.text,
                //   is_survey: false,
                // );

                // final box = Hive.box<OrderModel>('orders');
                // box.add(order);
              },
              child: const Text('Kirim'),
            ),
          ],
        ),
      );
    } else {
      // final formData =
      //     _controllers.map((key, controller) => MapEntry(key, controller.text));
      // // Tampilkan alert dialog dengan JSON
      // await showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: const Text('Data Form (Preview JSON)'),
      //     content: SingleChildScrollView(
      //       child: SelectableText(
      //         const JsonEncoder.withIndent('  ').convert(formData),
      //         style: const TextStyle(fontSize: 12),
      //       ),
      //     ),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.pop(context),
      //         child: const Text('Tutup'),
      //       ),
      //       TextButton(
      //         onPressed: () {
      //           Navigator.pop(context);
      //           // TODO: Kirim ke backend di sini
      //           print('Mengirim ke backend: $formData');
      //         },
      //         child: const Text('Kirim'),
      //       ),
      //     ],
      //   ),
      // );
      print('Form tidak valid!');
    }

    // Clear form kalau mau
    // _controllers.forEach((key, controller) => controller.clear());

    // if (!context.mounted) return; // ✅ aman
    // Navigator.pushNamedAndRemoveUntil(
    //   context,
    //   '/daftar-konsumen',
    //   (_) => false,
    // );
  }

  final Map<String, int> genderLabelToValue = {
    'LAKI-LAKI': 1,
    'PEREMPUAN': 2,
  };

  final Map<int, String> genderValueToLabel = {
    1: 'LAKI-LAKI',
    2: 'PEREMPUAN',
  };

  @override
  void initState() {
    super.initState();
    _controllers['statuspernikahan']!.text = 'Belum Menikah';
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FORM ORDER')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
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
                    _controllers['cabang']!.text = value;
                  });
                },
                validator: (value) {
                  return validateField('cabang', 'Cabang', value);
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
                          color:
                              status == 'Menikah' ? Colors.green : Colors.grey,
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
                    _controllers['statuspernikahan']!.text = value;
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
              // fieldBuilder(
              //   context: context,
              //   label: 'Jenis Kelamin',
              //   key: 'jeniskelamin',
              //   controllers: _controllers,
              // ),
              // WIDGET DROPDOWN JENIS KELAMIN SECARA LANGSUNG
              // DropdownButtonFormField2<String>(
              //   value: _controllers['jeniskelamin']!.text.isEmpty
              //       ? null
              //       : _controllers['jeniskelamin']!.text,
              //   isExpanded: true,
              //   decoration: InputDecoration(
              //     labelText: 'Jenis Kelamin',
              //     filled: true,
              //     fillColor: Colors.grey.shade100,
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
              //   dropdownStyleData: DropdownStyleData(
              //     padding: EdgeInsets.zero,
              //     offset: const Offset(0, 0),
              //   ),
              //   buttonStyleData: const ButtonStyleData(
              //     padding: EdgeInsets.only(right: 8, left: 0),
              //   ),
              //   menuItemStyleData: const MenuItemStyleData(
              //     padding: EdgeInsets.only(left: 14, right: 14),
              //   ),
              //   items: ['-- Pilih Jenis Kelamin --', 'LAKI-LAKI', 'PEREMPUAN']
              //       .map((status) {
              //     return DropdownMenuItem(
              //       value:
              //           status == '-- Pilih Jenis Kelamin --' ? null : status,
              //       child: Text(status),
              //     );
              //   }).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       // setState di sini hanya akan rebuild dropdown ini
              //       _controllers['jeniskelamin']!.text = value ?? '';
              //     });
              //   },
              //   validator: (value) {
              //     return validateField('jeniskelamin', 'Jenis Kelamin', value);
              //   },
              // ),
              const SizedBox(height: 10),
              DropdownButtonFormField2<String>(
                value: genderValueToLabel.containsKey(
                        int.tryParse(_controllers['jeniskelamin']!.text))
                    ? genderValueToLabel[
                        int.tryParse(_controllers['jeniskelamin']!.text)]
                    : null,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
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
                    .map((label) {
                  return DropdownMenuItem(
                    value: label == '-- Pilih Jenis Kelamin --' ? null : label,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    // simpan kode ke controller, bukan label
                    if (value != null &&
                        genderLabelToValue.containsKey(value)) {
                      _controllers['jeniskelamin']!.text =
                          genderLabelToValue[value]!.toString(); // "1" atau "2"
                    } else {
                      _controllers['jeniskelamin']!.text = '';
                    }
                  });
                },
                validator: (value) {
                  return validateField('jeniskelamin', 'Jenis Kelamin', value);
                },
              ),

              FieldBuilder(
                label: 'Nama',
                keyName: 'nama',
                controllers: _controllers,
              ),
              FieldBuilder(
                label: 'NIK',
                keyName: 'nik',
                controllers: _controllers,
              ),
              FieldBuilder(
                label: 'Umur',
                keyName: 'umur',
                controllers: _controllers,
              ),
              FieldBuilder(
                label: 'Tempat Lahir',
                keyName: 'tempatlahir',
                controllers: _controllers,
              ),
              FieldBuilder(
                label: 'Tanggal Lahir',
                keyName: 'tgllahir',
                controllers: _controllers,
              ),

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
                          FieldBuilder(
                            label: 'Alamat',
                            keyName: 'alamat',
                            controllers: _controllers,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FieldBuilder(
                                  label: 'RT',
                                  keyName: 'rt',
                                  controllers: _controllers,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '/',
                                style: blackTextStyle.copyWith(fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FieldBuilder(
                                  label: 'RW',
                                  keyName: 'rw',
                                  controllers: _controllers,
                                ),
                              )
                            ],
                          ),
                          FieldBuilder(
                            label: 'Kelurahan/Desa',
                            keyName: 'kel',
                            controllers: _controllers,
                          ),
                          FieldBuilder(
                            label: 'Kecamatan',
                            keyName: 'kec',
                            controllers: _controllers,
                          ),
                          FieldBuilder(
                            label: 'Kota',
                            keyName: 'kota',
                            controllers: _controllers,
                          ),
                          FieldBuilder(
                            label: 'Provinsi',
                            keyName: 'provinsi',
                            controllers: _controllers,
                          ),
                          FieldBuilder(
                            label: 'Kode Pos',
                            keyName: 'kodepos',
                            controllers: _controllers,
                          ),
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
                if (_spouseImage != null)
                  Image.file(_spouseImage!, height: 200),
                const SizedBox(height: 10),
                FieldBuilder(
                  label: 'Nama',
                  keyName: 'namapasangan',
                  controllers: _controllers,
                ),
                FieldBuilder(
                  label: 'NIK',
                  keyName: 'nikpasangan',
                  controllers: _controllers,
                ),
                FieldBuilder(
                  label: 'Umur',
                  keyName: 'umurpasangan',
                  controllers: _controllers,
                ),
                FieldBuilder(
                  label: 'Tempat Lahir',
                  keyName: 'tempatlahirpasangan',
                  controllers: _controllers,
                ),
                FieldBuilder(
                  label: 'Tanggal Lahir',
                  keyName: 'tgllahirpasangan',
                  controllers: _controllers,
                ),
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
                            FieldBuilder(
                              label: 'Alamat',
                              keyName: 'alamatpasangan',
                              controllers: _controllers,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: FieldBuilder(
                                    label: 'RT',
                                    keyName: 'rtpasangan',
                                    controllers: _controllers,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '/',
                                  style: blackTextStyle.copyWith(fontSize: 16),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FieldBuilder(
                                    label: 'RW',
                                    keyName: 'rwpasangan',
                                    controllers: _controllers,
                                  ),
                                )
                              ],
                            ),
                            FieldBuilder(
                              label: 'Kelurahan/Desa',
                              keyName: 'kelpasangan',
                              controllers: _controllers,
                            ),
                            FieldBuilder(
                              label: 'Kecamatan',
                              keyName: 'kecpasangan',
                              controllers: _controllers,
                            ),
                            FieldBuilder(
                              label: 'Kota',
                              keyName: 'kotapasangan',
                              controllers: _controllers,
                            ),
                            FieldBuilder(
                              label: 'Provinsi',
                              keyName: 'provinsipasangan',
                              controllers: _controllers,
                            ),
                            FieldBuilder(
                              label: 'Kode Pos',
                              keyName: 'kodepospasangan',
                              controllers: _controllers,
                            ),
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

              FieldBuilder(
                label: 'Nama Dealer',
                keyName: 'dealer',
                controllers: _controllers,
              ),
              FieldBuilder(
                label: 'Catatan CMO (jika ada)',
                keyName: 'catatan',
                controllers: _controllers,
              ),
              const SizedBox(height: 30),
              CustomFilledButton(
                title: 'Submit',
                onPressed: () => _submitForm(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
