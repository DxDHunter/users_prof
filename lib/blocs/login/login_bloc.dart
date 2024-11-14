import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userService = UserRepository();
  late SharedPreferences _prefs;

  LoginBloc() : super(const LoginInitial()) {
    _initialize(); // Appel de l'initialisation asynchrone
  }

  // Méthode asynchrone pour initialiser les préférences et exécuter le login auto
  Future<void> _initialize() async {
    await _initPrefs(); // Initialisation de SharedPreferences
    _autoLogin();       // Vérifie si l'utilisateur doit être connecté automatiquement

    on<LoginEmailChanged>((event, emit) {
      final currentState = state;
      if (currentState is LoginInitial) {
        emit(LoginInitial(email: event.email, password: currentState.password));
      }
    });

    on<LoginPasswordChanged>((event, emit) {
      final currentState = state;
      if (currentState is LoginInitial) {
        emit(LoginInitial(email: currentState.email, password: event.password));
      }
    });

    on<LoginSubmitted>((event, emit) async {
      final currentState = state;
      if (currentState is LoginInitial) {
        emit(const LoginLoading());
        try {
          final users = await _userService.fetchUsers();
          final existingUser = users.firstWhere(
                (u) => u.email == currentState.email && u.password == currentState.password,
            orElse: () => throw Exception('Invalid email or password'),
          );

          // Utilisez _prefs pour enregistrer l'utilisateur avec rememberMe
          await _userService.saveUser(existingUser);
          await _prefs.setBool('rememberMe', event.rememberMe);
          await _prefs.setString('userId', existingUser.id);

          emit(LoginSuccess(user: existingUser));
        } catch (error, stackTrace) {
          var logger = Logger();
          logger.e('Erreur lors de l’inscription : $error');
          logger.e('Stack trace: $stackTrace');
          emit(LoginFailure(error.toString()));
          // Revenir à l'état initial après un court délai
          await Future.delayed(const Duration(seconds: 1));
          emit(const LoginInitial());
        }
      }
    });

    on<LoginLogout>((event, emit) async {
      // Logique pour gérer la déconnexion
      await _userService.clearUser();
      await _prefs.remove('rememberMe');
      await _prefs.remove('userId');
      emit(const LoginInitial());
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _autoLogin() async {
    final rememberMe = _prefs.getBool('rememberMe') ?? false;

    if (rememberMe) {
      final user = await _userService.getUser();
      if (user != null) {
        emit(const LoginLoading());
        try {
          final users = await _userService.fetchUsers();

          // Utilisation de `orElse` pour gérer le cas où aucun utilisateur ne correspond
          final existingUser = users.firstWhere(
                (u) => u.email == user.email && u.password == user.password,
            orElse: () => throw Exception('No matching user found'), // Retourne `null` si aucun utilisateur n'est trouvé
          );

          if (existingUser != null && existingUser.id.isNotEmpty) {
            await Future.delayed(const Duration(milliseconds: 500));
            emit(LoginSuccess(user: existingUser));
          } else {
            // Aucun utilisateur trouvé ou ID vide, réinitialiser l'état
            await _userService.clearUser();
            emit(const LoginInitial());
          }
        } catch (error) {
          var logger = Logger();
          logger.e('Erreur lors de la connexion automatique : $error');
          await _userService.clearUser();
          emit(const LoginInitial());
        }
      } else {
        emit(const LoginInitial());
      }
    } else {
      emit(const LoginInitial());
    }
  }
}
