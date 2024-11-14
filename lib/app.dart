import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presence_of_teacher/blocs/login/login_bloc.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userId;

  const MyApp({required this.isLoggedIn,this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginBloc(),
        child: MaterialApp(
        title: 'Presence of Teacher',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: isLoggedIn ? '/home' : '/login',
        routes: {
          '/home': (context) {
            if (userId != null) {
              // Passe directement `userId` à `HomeScreen`
              return HomeScreen(userId: userId!);
            } else {
              // Gère le cas où `userId` est manquant
              return const Scaffold(
                body: Center(child: Text('Erreur : User ID manquant')),
              );
            }
          },
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
        },
      )
    );
  }
}

