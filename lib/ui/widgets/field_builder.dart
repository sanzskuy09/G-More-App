import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:gmore/shared/theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gmore/utils/field_validator.dart';
import 'package:intl/intl.dart';

class FieldBuilder extends StatelessWidget {
  final String label;
  final String keyName;
  final Map<String, TextEditingController> controllers;
  final Function(DateTime selectedDate)? onDateSelected;

  const FieldBuilder({
    super.key,
    required this.label,
    required this.keyName,
    required this.controllers,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textCapitalization: TextCapitalization.characters,
        keyboardType: ['rt', 'rw', 'umur', 'kodepos', 'nik'].contains(keyName)
            ? TextInputType.number
            : TextInputType.text,
        controller: controllers[keyName],
        readOnly: keyName == 'tgllahir' || keyName == 'tgllahirpasangan',
        onTap: keyName == 'tgllahir' || keyName == 'tgllahirpasangan'
            ? () async {
                // DateTime? pickedDate = await showDatePicker(
                //   context: context,
                //   initialDate: DateTime.now(),
                //   firstDate: DateTime(1900),
                //   lastDate: DateTime.now(),
                // );
                // if (pickedDate != null) {
                //   final formattedDate =
                //       "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                //   controllers[keyName]!.text = formattedDate;
                // }
                var datePicked = await DatePicker.showSimpleDatePicker(
                  context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  // lastDate: DateTime.now(),
                  dateFormat: "dd-MM-yyyy",
                  locale: DateTimePickerLocale.id,
                  looping: false,
                );

                if (datePicked != null) {
                  onDateSelected!(datePicked);
                  // final formattedDate =
                  //     "${datePicked.day.toString().padLeft(2, '0')}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.year}";
                  // final formattedDateForUI =
                  //     DateFormat('yyyy-MM-dd').format(datePicked);
                  // controllers[keyName]!.text = datePicked;
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
          suffixIcon: keyName == 'tgllahir' || keyName == 'tgllahirpasangan'
              ? const Icon(Icons.calendar_today)
              : null,
        ),
        validator: (value) {
          // print('Key name: $keyName, Label: $label, Value: $value');
          return validateField(keyName, label, value);
        },
      ),
    );
  }
}

Widget fieldSpouseBuilder({
  required BuildContext context,
  required String label,
  required String key,
  required Map<String, TextEditingController> controllers,
}) {
  // HANYA UNTUK TextFormField
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: TextFormField(
      textCapitalization: TextCapitalization.characters,
      keyboardType: key == 'rt' ||
              key == 'rw' ||
              key == 'umur' ||
              key == 'kodepos' ||
              key == 'nik'
          ? TextInputType.number
          : TextInputType.text,
      controller: controllers[key],
      readOnly: key == 'tgllahir' || key == 'tgllahirpasangan' ? true : false,
      onTap: key == 'tgllahir' || key == 'tgllahirpasangan'
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
                controllers[key]!.text = formattedDate;
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
        suffixIcon: key == 'tgllahir' || key == 'tgllahirpasangan'
            ? const Icon(Icons.calendar_today)
            : null,
      ),
      validator: (value) {
        // Panggil fungsi validasi global Anda
        print('Key pasangan: $key, Label: $label, Value: $value');
        return validateField(key, label, value);
      },
    ),
  );
}
