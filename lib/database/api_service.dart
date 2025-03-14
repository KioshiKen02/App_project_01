import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://your-domain.com/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<void> syncData(List<Map<String, dynamic>> localData) async {
    await http.post(
      Uri.parse('$baseUrl/sync'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'data': localData}),
    );
  }
}
