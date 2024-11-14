import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final rememberMe = prefs.getBool('rememberMe') ?? false;

  runApp(MyApp(isLoggedIn: rememberMe && userId != null, userId: userId));
}
