// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/signup/signup_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'home_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocProvider(
        create: (context) => SignupBloc(),
        child: SignupForm(),
      ),
    );
  }
}

// Ajoutez un champ pour stocker le chemin de l'image
class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  SignupFormState createState() => SignupFormState();
}

class SignupFormState extends State<SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? _selectedImagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
        if (state is SignupSuccess) {
          final user = state.user;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signup Successful: Welcome, ${user.firstName} ${user.lastName}!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(userId: user.id),
            ),
          );
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Champs de texte
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  // Bouton de sélection d'image
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _selectedImagePath = pickedFile.path;
                        });
                      }
                    },
                    child: Text(_selectedImagePath == null ? 'Select Image' : 'Change Image'),
                  ),

                  const SizedBox(height: 20),

                  state is SignupLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {
                      context.read<SignupBloc>().add(
                        SignupSubmitted(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          imagePath: _selectedImagePath, // Utilise l'image sélectionnée
                        ),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
