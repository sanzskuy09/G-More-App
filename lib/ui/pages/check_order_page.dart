import 'package:flutter/material.dart';
import 'package:gmore/ui/pages/not_found_page.dart';

class CheckOrderPage extends StatelessWidget {
  const CheckOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Order'),
        automaticallyImplyLeading: false,
      ),
      body: NotFoundPage(),
    );
  }
}
