part of 'user_bloc.dart';

abstract class UserState {}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<User> users;
  UsersLoaded(this.users);
}

class UsersError extends UserState {
  final String message;
  UsersError(this.message);
}
