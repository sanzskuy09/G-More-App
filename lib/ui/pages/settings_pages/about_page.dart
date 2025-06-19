import 'package:flutter/material.dart';
import 'package:gmore/ui/pages/not_found_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String appName = '';
  String version = '';
  String buildNumber = '';
  final int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    loadAppInfo();
  }

  Future<void> loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appName = info.appName;
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo aplikasi (ganti asset sesuai logo kamu)
            CircleAvatar(
              radius: 100,
              backgroundImage:
                  AssetImage('assets/ic_logo.png'), // Pastikan file ada
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 16),
            Text(
              appName.isEmpty ? 'Aplikasi Saya' : appName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Versi $version (Build $buildNumber)',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Aplikasi ini dibuat untuk mempermudah pengguna dalam mengakses berbagai layanan yang dibutuhkan secara cepat dan efisien. '
              'Kami berkomitmen untuk terus mengembangkan fitur-fitur bermanfaat dan memberikan pengalaman terbaik.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.code, color: Colors.blueGrey),
                SizedBox(width: 8),
                Text('Dikembangkan oleh: Tim IT Gratama Finance'),
              ],
            ),
            const SizedBox(height: 8),
            Text('© $currentYear All rights reserved',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
