import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/database_helper.dart';
import '../models/user.dart';

class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  final _storage = const FlutterSecureStorage();

  Future<List<User>> fetchUsers() async {
    return await _databaseHelper.getAllUsers();
  }

  Future<void> addUser(User user) async {
    await _databaseHelper.insertUser(user);
  }

  Future<void> updateUser(User user) async {
    await _databaseHelper.updateUser(user);
  }

  Future<void> deleteUser(String id) async {
    await _databaseHelper.deleteUser(id);
  }

  Future<void> saveUser(User user) async {
    await _storage.write(key: 'email', value: user.email);
    await _storage.write(key: 'password', value: user.password);
  }


  Future<User?> getUser() async{
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    if (email != null && password != null){
      return User(
        id: '',
        email: email,
        password: password,
        firstName: '',
        lastName: '',
      );
    }
    return null;
  }
  Future<void> clearUser() async {
    await _storage.deleteAll();
  }
}
