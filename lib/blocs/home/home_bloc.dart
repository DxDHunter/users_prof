import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user.dart';
import '../../data/database_helper.dart'; // Assurez-vous que le chemin est correct

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DatabaseHelper databaseHelper;

  HomeBloc(this.databaseHelper) : super(HomeLoading()) {
    on<LoadHome>((event, emit) async {
      emit(HomeLoading());

      try {
        // Récupère l'utilisateur depuis la base de données
        User? currentUser = await databaseHelper.getUser(event.userId);

        if (currentUser == null) {
          emit(HomeError("User not found"));
        } else if (currentUser.role == 'admin') {
          emit(AdminHome(currentUser));
        } else {
          emit(UserHome(currentUser));
        }
      } catch (error) {
        emit(HomeError("Failed to load user"));
      }
    });

    on<SetUserRole>((event, emit) async {
      try {
        final User updatedUser = event.user.copyWith(role: event.role);
        await databaseHelper.updateUser(updatedUser);

        if (event.role == 'admin') {
          emit(AdminHome(updatedUser));
        } else {
          emit(UserHome(updatedUser));
        }
      } catch (error) {
        emit(HomeError("Failed to update user role"));
      }
    });
  }
}
