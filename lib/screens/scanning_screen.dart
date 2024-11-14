import 'package:flutter/material.dart';

class ScanningScreen extends StatelessWidget {
  const ScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanning')),
      body: const Center(
        child: Icon(
          Icons.qr_code_scanner,
          size: 200,
        ),
      ),
    );
  }
}
