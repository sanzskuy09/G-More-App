import 'package:flutter/material.dart';
import 'package:gmore/ui/pages/not_found_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      // body: Center(child: Image.asset('assets/ic_empty.png')),
      body: NotFoundPage(),
    );
  }
}
