part of 'scanning_bloc.dart';

abstract class ScanningState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ScanningInitial extends ScanningState {}

class QrCodeGenerated extends ScanningState {
  final String qrData;

  QrCodeGenerated(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

class QrCodeScanned extends ScanningState {
  final String scannedData;

  QrCodeScanned(this.scannedData);

  @override
  List<Object?> get props => [scannedData];
}