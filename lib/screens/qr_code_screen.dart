import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/user.dart';

class QRCodeScreen extends StatelessWidget {
  final User user;
  final String previousScreen;
  const QRCodeScreen({required this.user, required this.previousScreen, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: _generateQRCodeData(),
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 20),
              Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                user.email,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
    );
  }
  // Méthode pour générer les données du QR code
  String _generateQRCodeData() {
    return user.qrCodeUrl!;
  }
}
