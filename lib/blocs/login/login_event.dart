part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent(); // Constructeur constant par défaut

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginSubmitted({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object> get props => [email, password, rememberMe];
}

class LoginLogout extends LoginEvent {
  const LoginLogout();
}