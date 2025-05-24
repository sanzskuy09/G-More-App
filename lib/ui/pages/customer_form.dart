import 'package:flutter/material.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/widgets/buttons.dart';

class CustomerFormPage extends StatefulWidget {
  const CustomerFormPage({super.key});

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final TextEditingController _namaKonsumenController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  final _formFormat = GlobalKey<FormState>();
  bool isValidForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Form contoh'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Customer Form Data',
              style: blackTextStyle.copyWith(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Form(
            key: _formFormat,
            child: Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib diisi';
                      } else {
                        return null;
                      }
                    },
                    controller: _namaKonsumenController,
                    decoration: InputDecoration(
                      label: Text('Nama Konsumen'),
                      hintText: 'nama konsumen (sah)',
                      hintStyle: greyTextStyle,
                      prefixIcon: Icon(
                        Icons.person,
                        color: primaryColor,
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 60),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextFormField(
                    controller: _nomorTeleponController,
                    decoration: InputDecoration(
                      label: Text('Nomor Telepon'),
                      hintText: 'nomor telepon ',
                      hintStyle: greyTextStyle,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: primaryColor,
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 60),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: TextFormField(
                    maxLines: 2,
                    controller: _catatanController,
                    decoration: InputDecoration(
                      label: Text('Catatan'),
                      hintText: 'Isi catatan',
                      hintStyle: greyTextStyle,
                      prefixIcon: Padding(
                        // mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.file_copy,
                          color: primaryColor,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(minWidth: 60),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomFilledButton(
                    title: 'Submit',
                    onPressed: () {
                      if (_formFormat.currentState!.validate()) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Processing Data')),
                        // );
                        Navigator.pushNamed(context, '/new-order');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data Tidak Lengkap')),
                        );
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
