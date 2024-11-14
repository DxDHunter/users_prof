// home_event.dart

part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHome extends HomeEvent {
  final String userId; // Identifiant de l'utilisateur à charger

  LoadHome(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SetUserRole extends HomeEvent {
  final String role;
  final User user;

  SetUserRole({required this.role, required this.user});

  @override
  List<Object?> get props => [role, user];
}