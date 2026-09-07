import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'https://task.com/api'});

  Future<bool> login(String emailOrMobile, String password) async {
    if (baseUrl.contains('task.com')) {
      await Future.delayed(const Duration(milliseconds: 700));
      return emailOrMobile.trim().isNotEmpty && password.length >= 4;
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': emailOrMobile, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) return true;
      if (response.statusCode == 401) throw Exception('Invalid credentials');
      throw Exception('Login failed (${response.statusCode})');
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<dynamic>> getTasks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) return jsonDecode(response.body) as List<dynamic>;
    if (response.statusCode == 401) throw Exception('Authentication expired');
    throw Exception('Unable to fetch tasks (${response.statusCode})');
  }

  Future<bool> updateTask(String token, String taskId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    ).timeout(const Duration(seconds: 10));
    if (response.statusCode == 401) throw Exception('Authentication expired');
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
