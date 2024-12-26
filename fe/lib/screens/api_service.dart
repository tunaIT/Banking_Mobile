import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2:8081"; // URL cơ bản của API

  // Phương thức đăng nhập
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login'); // URL API cho đăng nhập

    try {
      print("😎😎😎😎$url");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Nếu đăng nhập thành công, trả về token
        return json.decode(response.body);
      } else {
        // Trả về lỗi nếu có
        return {'error': 'Login failed. Please check your credentials.'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Phương thức đăng ký
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register'); // URL API cho đăng ký

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Nếu đăng ký thành công, trả về dữ liệu phản hồi
        return json.decode(response.body);
      } else {
        // Trả về lỗi nếu có
        return {'error': 'Registration failed. Please try again.'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Phương thức lấy tên người dùng
  Future<Map<String, dynamic>> getUserInfo(String token) async {
    final response = await http.get(
      Uri.parse('https://api.example.com/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user info');
    }
  }
}

