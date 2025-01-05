import 'dart:convert';
import 'dart:typed_data';
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
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Trả về token nếu thành công
      } else {
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
        return json.decode(response.body); // Trả về dữ liệu phản hồi
      } else {
        return {'error': 'Registration failed. Please try again.'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Phương thức lấy thông tin người dùng
  Future<Map<String, dynamic>> getUserInfo(String token) async {
    final url = Uri.parse('$baseUrl/user'); // URL API lấy thông tin người dùng

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to fetch user info.'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Phương thức chuyển đổi tiền tệ
  static const String _apiUrlCurrency =
      "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_ZAQJFYT8lTFNWTTPtKpQLw329ifSJjhzALPjLHQB";

  Future<Map<String, dynamic>> fetchRates() async {
    try {
      final response = await http.get(Uri.parse(_apiUrlCurrency));
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        return {'error': 'Failed to load exchange rates.'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Phương thức lấy mã QR
  Future<Uint8List?> fetchQrCode(String token) async {
    final url = Uri.parse('$baseUrl/auth/generate-qr'); // URL API lấy mã QR

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // Trả về mã QR dưới dạng byte array
      } else {
        print('Error fetching QR Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Phương thức xác thực email
  Future<Map<String, dynamic>> verifyEmail(String email) async {
    final url = Uri.parse('$baseUrl/auth/verifyEmail/$email'); // URL API xác thực email

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Nếu thành công, trả về dữ liệu phản hồi
      } else {
        return {'error': 'Email verification failed.'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

  // Phương thức xác thực OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse('$baseUrl/auth/verifyOtp'); // API xác thực OTP

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Trả về phản hồi thành công
      } else {
        return {'error': 'OTP verification failed.'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

// Phương thức thay đổi mật khẩu
  Future<Map<String, dynamic>> changePassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/changePassword'); // API đổi mật khẩu

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,               // Gửi email
          'password': newPassword,      // Gửi mật khẩu mới
          'repeatPassword': confirmPassword,  // Gửi mật khẩu xác nhận
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Trả về phản hồi thành công
      } else {
        return {'error': 'Password change failed. Status code: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }

}
