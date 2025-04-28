import 'package:qrcode/cubit/qr_state.dart';
import 'package:bloc/bloc.dart';
import 'package:qrcode/database/db_helper.dart';

class QrCubit extends Cubit<QrState> {
  QrCubit() : super(QrInitial());

  void analyzeUrl(String url) async {
    emit(QrAnalyzing());

    await Future.delayed(const Duration(seconds: 2)); 

    final result = url.contains("valid") ? "Valid" : "Invalid";

    await DatabaseHelper().insertResult(url, result);

    if (result == "Valid") {
      emit(QrValid());
    } else {
      emit(QrInvalid());
    }
  }
}