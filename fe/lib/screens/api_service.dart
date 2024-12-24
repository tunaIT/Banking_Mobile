import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:8081"; // URL cơ bản của API

  // Đăng nhập
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await _postRequest(
      endpoint: "/auth/login",
      body: {'email': email, 'password': password},
    );
  }

  // **Private method cho POST request**
  Future<Map<String, dynamic>> _postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Phản hồi thành công
      } else {
        return {
          'error': jsonDecode(response.body)['error'] ??
              'Unknown error occurred'
        }; // Phản hồi lỗi từ server
      }
    } catch (e) {
      return {'error': 'Connection failed: $e'}; // Lỗi mạng hoặc lỗi khác
    }
  }
}
