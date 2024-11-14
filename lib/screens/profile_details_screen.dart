import 'package:flutter/material.dart';
import 'dart:io';
import '../models/user.dart';

class ProfileDetailsScreen extends StatelessWidget {
  final User user;
  final String previousScreen;

  const ProfileDetailsScreen({required this.user, required this.previousScreen, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: buildImageWidget(user.imageUrl, 'assets/images/1.png', width: 100, height: 100),
              ),
            ),
            _buildUserDetail('Nom complet', '${user.firstName} ${user.lastName}'),
            _buildUserDetail('Email', user.email),
          ],
        ),
      ),
    );
  }

  // Méthode générique pour afficher une image avec une image de secours
  Widget buildImageWidget(String? imageUrl, String fallbackAsset, {double width = 150, double height = 150}) {
    if (imageUrl != null && Uri.tryParse(imageUrl)?.isAbsolute == true) {
      // Image réseau
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          fallbackAsset,
          width: width,
          height: height,
        ),
      );
    } else if (imageUrl != null && File(imageUrl).existsSync()) {
      // Image locale depuis un fichier
      return Image.file(
        File(imageUrl),
        width: width,
        height: height,
      );
    } else {
      // Image de secours
      return Image.asset(
        fallbackAsset,
        width: width,
        height: height,
      );
    }
  }

  // Méthode privée pour afficher chaque détail de l'utilisateur
  Widget _buildUserDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
