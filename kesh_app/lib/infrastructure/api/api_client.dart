import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = 'http://localhost:3000/api';

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('RESPOSTA: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Erro HTTP ${response.statusCode}: ${response.body}');
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

    // Exibe informações da requisição
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('RESPOSTA: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erro HTTP ${response.statusCode}: ${response.body}');
    }

    if (response.body.isEmpty) {
      return {};
    }

    return jsonDecode(response.body);
  }
}
