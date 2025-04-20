import 'dart:convert';
import 'package:airsolo/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrlMain = Config.baseUrl; 

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrlMain/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token']; 
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  }

  Future<void> getAdminData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrlMain/api/users/admin-only'),
      headers: {
        'Authorization': 'Bearer $token', 
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Admin data: $data');
    } else {
      print('Failed to access admin data: ${response.body}');
    }
  }


 /// ---- Api Service Update ---- ///
 
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }



    Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrlMain/$endpoint'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse('$baseUrlMain/$endpoint'),
      headers: await _getHeaders(),
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    final response = await http.put(
      Uri.parse('$baseUrlMain/$endpoint'),
      headers: await _getHeaders(),
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrlMain/$endpoint'),
      headers: await _getHeaders(),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }





}
