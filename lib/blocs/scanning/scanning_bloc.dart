import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../models/user.dart';
part 'scanning_event.dart';
part 'scanning_state.dart';

class ScanningBloc extends Bloc<ScanningEvent, ScanningState> {
  ScanningBloc() : super(ScanningInitial()) {
    on<GenerateQrCode>((event, emit) {
      final qrData = 'Professor: ${event.user.firstName} ${event.user.lastName}';
      emit(QrCodeGenerated(qrData));
    });

    on<ScanQrCode>((event, emit) async {
      String scannedData = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR
      );
      if (scannedData != '-1') {
        emit(QrCodeScanned(scannedData));
      }
    });
  }
}