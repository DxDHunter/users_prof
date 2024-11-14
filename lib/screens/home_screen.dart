import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presence_of_teacher/screens/profile_details_screen.dart';
import 'package:presence_of_teacher/widgets/app_bar.dart';
import '../blocs/home/home_bloc.dart';
import '../data/database_helper.dart';
import '../models/user.dart';
import 'qr_code_screen.dart';
import 'scanning_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    final databaseHelper = DatabaseHelper.instance;

    return BlocProvider(
      create: (context) => HomeBloc(databaseHelper)..add(LoadHome(userId)), // Assurez-vous de fournir un userId ici
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Scaffold(
              appBar: MyAppBar(title: 'Accueil'),
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is UserHome) {
            return UserHomeScreen(currentUser: state.currentUser);
          } else if (state is AdminHome) {
            return AdminHomeScreen(currentUser: state.currentUser);
          } else if (state is HomeError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Accueil')),
              body: Center(child: Text(state.message)),
            );
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text('Accueil')),
              body: const Center(child: Text('Un état inattendu a été rencontré')),
            );
          }
        },
      ),
    );
  }
}


class UserHomeScreen extends StatelessWidget {
  final User currentUser;

  const UserHomeScreen({required this.currentUser,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Accueil'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuItem(
              context,
              icon: Icons.person,
              label: 'Infos Personnelles',
              onTap: () {
                // Naviguer vers la page des infos personnelles
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileDetailsScreen(
                      user: currentUser,
                      previousScreen: '/Home')
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.qr_code,
              label: 'QR Code',
              onTap: () {
                // Naviguer vers la page QR Code
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRCodeScreen(
                    user: currentUser,
                    previousScreen: '/Home',)
                  ),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings,
              label: 'Paramètres',
              onTap: () {
                // Naviguer vers les paramètres
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AdminHomeScreen extends StatelessWidget {
  final User currentUser;
  const AdminHomeScreen({required this.currentUser, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Accueil'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuItem(
              context,
              icon: Icons.person,
              label: 'Liste des Profils',
              onTap: () {
                // Naviguer vers la liste des profils
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings,
              label: 'Paramètres',
              onTap: () {
                // Naviguer vers les paramètres
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.qr_code_scanner,
              label: 'Scanning',
              onTap: () {
                // Naviguer vers la page de scanning
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanningScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, required Function() onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
