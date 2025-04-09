import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://127.0.0.1:3000'; 

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token']; // Return the JWT token
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  }

  Future<void> getAdminData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/admin-only'),
      headers: {
        'Authorization': 'Bearer $token', // Use the JWT token
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Admin data: ${data}');
    } else {
      print('Failed to access admin data: ${response.body}');
    }
  }
}
