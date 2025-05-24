import 'package:flutter/material.dart';
import 'package:gmore/ui/pages/not_found_page.dart';

class PromoPage extends StatelessWidget {
  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo'),
      ),
      body: NotFoundPage(),
    );
  }
}
