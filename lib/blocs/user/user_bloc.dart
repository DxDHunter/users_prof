import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';
part 'user_event.dart';
part 'user_state.dart';

class ProfessorBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  ProfessorBloc(this._repository) : super(UsersLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(
      LoadUsers event, Emitter<UserState> emit) async {
    try {
      final users = await _repository.fetchUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError("Erreur de chargement des professeurs"));
    }
  }

  Future<void> _onAddUser(
      AddUser event, Emitter<UserState> emit) async {
    await _repository.addUser(event.user);
    add(LoadUsers()); // Recharger les professeurs après ajout
  }

  Future<void> _onUpdateUser(
      UpdateUser event, Emitter<UserState> emit) async {
    await _repository.updateUser(event.user);
    add(LoadUsers()); // Recharger les professeurs après mise à jour
  }

  Future<void> _onDeleteUser(
      DeleteUser event, Emitter<UserState> emit) async {
    await _repository.deleteUser(event.id);
    add(LoadUsers()); // Recharger les professeurs après suppression
  }
}
