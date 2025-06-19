import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gmore/shared/theme.dart';
import 'package:gmore/ui/widgets/task_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    checkStorage();

    /// Scroll ke atas saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(0); // atau .animateTo() untuk animasi
    });
  }

  void checkStorage() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    // print('Stored token: $token');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar(),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                children: [
                  // headerSection(),
                  profileSection(),
                  sisaTaskSection(),
                  taskSection(),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomAppBar() {
    return Container(
      // color: whiteColor,
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri: Judul
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'G-MORE',
                style: primaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
            ],
          ),

          // Kanan: Icon search + notifikasi
          Row(
            children: [
              Icon(
                Icons.search,
                color: primaryColor,
                size: 28,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.notifications,
                color: primaryColor,
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 30),
      // padding: EdgeInsets.symmetric(
      //   vertical: 20,
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'G-MORE',
                style: primaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
              // SizedBox(
              //   height: 2,
              // ),
              // Text(
              //   'Salman AF',
              //   style:
              //       blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
              // )
            ],
          ),
          Row(children: [
            Icon(
              Icons.search,
              color: primaryColor,
              size: 30,
            ),
            SizedBox(width: 15),
            Icon(
              Icons.notifications,
              color: primaryColor,
              size: 30,
            ),
          ])
        ],
      ),
    );
  }

  Widget profileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
      // height: ,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: lightBackgorundColor, width: 1),
        // boxShadow: [
        //   BoxShadow(
        //     color: lightBackgorundColor,
        //     blurRadius: 10,
        //     offset: Offset(0, 10),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Salman AF',
            style: primaryTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lightBackgorundColor,
                ),
                child: Icon(Icons.person, color: blackColor, size: 40),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONSUMER FINANCE',
                      style: blackTextStyle.copyWith(
                          fontSize: 16, fontWeight: semiBold),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Credit Marketing Officer',
                      softWrap: true,
                      overflow: TextOverflow.visible, // ✅ biar tidak dipotong
                      style: greyTextStyle.copyWith(
                          fontSize: 12, fontWeight: light),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'BOGOR',
                      style: blackTextStyle.copyWith(
                          fontSize: 16, fontWeight: semiBold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sisaTaskSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sisa Task',
            style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: whiteColor, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Center(
              child: Text(
                '12',
                style: whiteTextStyle.copyWith(fontWeight: semiBold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget taskSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Task',
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
          ),
          const SizedBox(
            height: 16,
          ),
          TaskListComponent(title: 'Task Gagal Diterima'),
          TaskListComponent(title: 'Task Berhasil Diterima'),
          TaskListComponent(title: 'Task Tidak Terkirim'),
          TaskListComponent(title: 'Task Selesai'),
        ],
      ),
    );
  }
}
