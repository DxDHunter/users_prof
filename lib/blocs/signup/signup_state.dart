part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const SignupInitial({
    this.email = '',
    this.password = '',
    this.firstName = '',
    this.lastName = '',
  });

  SignupInitial copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
  }) {
    return SignupInitial(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

class SignupLoading extends SignupState {
    const SignupLoading();
}

class SignupSuccess extends SignupState {
  final User user;

  const SignupSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class SignupFailure extends SignupState {
  final String error;

  const SignupFailure(this.error);

  @override
  List<Object> get props => [error];
}
