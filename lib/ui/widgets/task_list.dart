import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gmore/shared/theme.dart';

class TaskListComponent extends StatelessWidget {
  final String title;

  const TaskListComponent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: lightBackgorundColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  selectionColor: primaryColor,
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                    fontWeight: bold,
                  )),
              Text(
                '4 jam yang lalu',
                style: greyTextStyle.copyWith(
                  fontSize: 8,
                  fontWeight: medium,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          AutoSizeText(
            'Tidak ada koneksi Internet sakjdasuh gsuayd fguagsidua -N sadghusaidgi',
            style: blackTextStyle.copyWith(
              fontSize: 12,
              fontWeight: medium,
            ),
            minFontSize: 10,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
          // SizedBox(
          //   width: 180,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'Task Gagal Diterima',
          //         style: blackTextStyle.copyWith(
          //           fontSize: 16,
          //           fontWeight: semiBold,
          //         ),
          //       ),
          //       SizedBox(
          //         height: 15,
          //       ),
          //       AutoSizeText(
          //         'Tidak ada koneksi Internet sakjdasuhgsuaydfguagsidua -N sadghusaidgi',
          //         style: blackTextStyle.copyWith(
          //           fontSize: 12,
          //           fontWeight: medium,
          //         ),
          //         minFontSize: 10,
          //         maxLines: 3,
          //         overflow: TextOverflow.ellipsis,
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
