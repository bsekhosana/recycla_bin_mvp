import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthRepository {
  final String apiUrl = 'http://10.0.2.2:5000/api/auth'; // 'http://localhost:5000/api/auth';

  Future<User> register(Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    print(response);
    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<User> login(Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final user = User.fromJson(responseData['user']);
      final token = responseData['token'];

      // Store token in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return user;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
