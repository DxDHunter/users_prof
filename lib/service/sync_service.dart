import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/database_helper.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';

class SyncService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final String serverUrl = 'http://192.168.1.175:3000';

  // Télécharger les utilisateurs depuis le serveur et les stocker localement
  Future<void> fetchAndStoreUsers() async {
    final response = await http.get(Uri.parse('$serverUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> usersData = jsonDecode(response.body);
      for (var userData in usersData) {
        final userFromServer = User.fromJson(userData);

        // Récupère l'utilisateur local avec le même ID
        final localUser = await _dbHelper.getUser(userFromServer.id);

        // Si l'utilisateur n'existe pas localement ou que la version du serveur est plus récente
        if (localUser == null || userFromServer.updatedAt.compareTo(localUser.updatedAt) > 0) {
          await _dbHelper.insertUser(userFromServer); // Met à jour ou insère l'utilisateur
        }
      }} else {
      throw Exception('Erreur de téléchargement des utilisateurs');
    }
  }

  // Envoyer les utilisateurs locaux qui ne sont pas encore sur le serveur
  Future<void> syncLocalToServer() async {
    final localUsers = await _dbHelper.getAllUsers();

    for (var user in localUsers) {
      // Vérifier si l'utilisateur existe sur le serveur
      final response = await http.get(Uri.parse('$serverUrl/users/${user.id}'));
      if (response.statusCode == 200) {
        final serverUserData = jsonDecode(response.body);
        final serverUser = User.fromJson(serverUserData);

        // Synchroniser uniquement si l'utilisateur local est plus récent
        if (user.updatedAt.compareTo(serverUser.updatedAt) > 0) {
          // Exclure le champ `role` lors de la synchronisation
          final dataToSync = {
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'password': user.password,
            'imageUrl': user.imageUrl,
            'qrCodeUrl': user.qrCodeUrl,
            'updatedAt': user.updatedAt,
          };

          final syncResponse = await http.post(
            Uri.parse('$serverUrl/users/${user.id}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(dataToSync),
          );

          if (syncResponse.statusCode != 200) {
            var logger = Logger();
            logger.e('Erreur lors de la synchronisation de ${user.email}');
          }
        }
      }
    }
  }

}
