import 'dart:ui';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/user.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../repositories/user_repository.dart';
part 'signup_state.dart';
part 'signup_event.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository _userService = UserRepository();

  SignupBloc() : super(const SignupInitial()) {
    on<SignupEmailChanged>((event, emit) {
      emit((state as SignupInitial).copyWith(email: event.email));
    });

    on<SignupPasswordChanged>((event, emit) {
      emit((state as SignupInitial).copyWith(password: event.password));
    });

    on<SignupFirstNameChanged>((event, emit) {
      emit((state as SignupInitial).copyWith(firstName: event.firstName));
    });

    on<SignupLastNameChanged>((event, emit) {
      emit((state as SignupInitial).copyWith(lastName: event.lastName));
    });

    on<SignupSubmitted>((event, emit) async {
      emit(SignupLoading());
      try {
        final existingUser = (await _userService.fetchUsers()).any(
              (user) => user.email == event.email,
        );

        if (existingUser) {
          emit(const SignupFailure('Email already exists'));
        } else {
          // Utilise l'image fournie si elle est disponible, sinon obtient l'image par défaut
          final imageUrl = event.imagePath ?? await _getDefaultImage();
          // Créer un nouvel utilisateur avec des données initiales
          final newUser = User(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            lastName: event.lastName,
            firstName: event.firstName,
            email: event.email,
            password: event.password,
            imageUrl: imageUrl,
            qrCodeUrl: await _generateQRCode(event.email),
          );

          // Ajouter l’utilisateur à la base de données
          await _userService.addUser(newUser);
          emit(SignupSuccess(user: newUser));
        }
      } catch (error, stackTrace) {
        var logger = Logger();
        // Affiche l'erreur et la trace de l'erreur dans les logs
        logger.e('Erreur lors de l’inscription : $error');
        logger.e('Stack trace: $stackTrace');
        emit(SignupFailure(error.toString()));
        // Revenir à l'état initial après un court délai
        await Future.delayed(const Duration(seconds: 1));
        emit(const SignupInitial());
      }
    });
  }

  // Génère le QR code basé sur l'email de l'utilisateur et renvoie l'URL de l'image QR
  Future<String> _generateQRCode(String email) async {
    final qrValidationData = 'User Email: $email';
    final qrCode = QrPainter(
      data: qrValidationData,
      version: QrVersions.auto,
      gapless: false,
    );

    final tempDir = await getTemporaryDirectory();
    final qrFilePath = '${tempDir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
    final qrFile = File(qrFilePath);

    // Générez l'image du QR code en tant que ByteData
    final ByteData? byteData = await qrCode.toImage(200).then((image) => image.toByteData(format: ImageByteFormat.png));

    // Vérifiez que byteData n'est pas null avant d'accéder à buffer
    if (byteData != null) {
      await qrFile.writeAsBytes(byteData.buffer.asUint8List());
    } else {
      throw Exception("Failed to generate QR code image data");
    }

    return qrFilePath; // Retourne le chemin de l'image QR code générée
  }


// Renvoie une URL d'image par défaut si aucune n'est spécifiée
  Future<String> _getDefaultImage() async {
    // Utilisez une URL d'image par défaut ou un chemin local dans vos ressources
    return 'resources/1.png';
  }

}
