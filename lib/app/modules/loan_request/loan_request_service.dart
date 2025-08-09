import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'loan_request_provider.dart';

class LoanRequestService {
  final http.Client _client;
  LoanRequestService({http.Client? client}) : _client = client ?? http.Client();

  Future<String> _fileToBase64(String path) async {
    final bytes = await File(path).readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> submit(LoanRequestState state) async {
    final payload = {
      'cardFront': await _fileToBase64(state.cardFront!),
      'ineFront': await _fileToBase64(state.ineFront!),
      'ineBack': await _fileToBase64(state.ineBack!),
      'docPhoto': await _fileToBase64(state.docPhoto!),
      'signaturePng': await _fileToBase64(state.signaturePngPath!),
      'deviceUuid': const Uuid().v4(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    final response = await _client.post(
      Uri.parse('https://api.ejemplo.com/loan/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException('HTTP ${response.statusCode}');
    }
  }
}


final loanRequestServiceProvider = Provider((ref) => LoanRequestService());
