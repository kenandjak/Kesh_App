import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  final String baseUrl = 'http://localhost:3000/api';

  String _getMessage(String body) {
    final data = jsonDecode(body);

    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? 'Erro na API';
    }

    return 'Erro na comunicação com a API';
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('RESPOSTA: ${response.body}');

    if (response.statusCode != 200) {
      throw ApiException(
        statusCode: response.statusCode,
        message: _getMessage(response.body),
      );
    }

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('RESPOSTA: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: _getMessage(response.body),
      );
    }

    if (response.body.isEmpty) {
      return {};
    }

    return jsonDecode(response.body);
  }
}
