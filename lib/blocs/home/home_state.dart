// home_state.dart

part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserHome extends HomeState {
  final User currentUser;

  UserHome(this.currentUser);

  @override
  List<Object?> get props => [currentUser];
}

class AdminHome extends HomeState {
  final User currentUser;

  AdminHome(this.currentUser);

  @override
  List<Object?> get props => [currentUser];
}
