part of 'scanning_bloc.dart';

abstract class ScanningEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GenerateQrCode extends ScanningEvent {
  final User user;

  GenerateQrCode({required this.user});

  @override
  List<Object?> get props => [user];
}

class ScanQrCode extends ScanningEvent {}
