import 'package:bloc/bloc.dart';
import 'package:qrcode/cubit/qr_state.dart';
import 'package:qrcode/database/db_helper.dart';
import 'package:qrcode/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class QrCubit extends Cubit<QrState> {
  final ApiService apiService;

  QrCubit(this.apiService) : super(QrInitial());

  Future<void> analyzeUrl(String url) async {
    try {
      print("Starting URL analysis for: $url");

      // Send JSON request to backend
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/check_url'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );
      print("Response body: ${response.body}");

      print("Received response with status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        print("Response data from backend: $data");

        // Use 'status' field from backend ('Benign' or 'Malicious')
        if (data['status'] == 'Benign') {
          print("URL is benign.");
          emit(QrValid()); // emit valid state
        } else {
          print("URL is malicious.");
          emit(QrInvalid()); // emit invalid state
        }
      } else {
        print("Error from backend: ${response.statusCode}");
        emit(QrError(message: 'Error from backend: ${response.statusCode}'));
      }
    } catch (e) {
      print("An error occurred during URL analysis: $e");
      emit(QrError(message: 'An error occurred: $e'));
    }
  }
}
