part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  const SignupEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  const SignupPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class SignupFirstNameChanged extends SignupEvent {
  final String firstName;

  const SignupFirstNameChanged(this.firstName);

  @override
  List<Object> get props => [firstName];
}

class SignupLastNameChanged extends SignupEvent {
  final String lastName;

  const SignupLastNameChanged(this.lastName);

  @override
  List<Object> get props => [lastName];
}

class SignupSubmitted extends SignupEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? imagePath;

  const SignupSubmitted({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.imagePath,
  });

  @override
  List<Object> get props => [firstName, lastName, email, password, imagePath!];
}