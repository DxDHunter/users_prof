part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  final String email;
  final String password;

  const LoginInitial({this.email = '', this.password = ''});

  @override
  List<Object?> get props => [email, password];
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final User user;

  const LoginSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure([this.error = '']); // Ajout d'une valeur par défaut pour error

  @override
  List<Object> get props => [error];
}
