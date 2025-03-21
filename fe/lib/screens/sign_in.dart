import 'package:flutter/material.dart';
import '../services/token_service.dart';
import '../services/api_service.dart'; // Import lớp ApiService bạn đã tạo
import 'sign_up.dart';
import 'forgot_password.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true; // Để theo dõi trạng thái ẩn/hiện mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF2136D6),
        elevation: 0,
        title: Text("Sign in"),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F1DCD),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Hello there, sign in to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 40),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFEEE8F5),
                  child: Icon(Icons.lock, size: 50, color: Color(0xFF5025BF)),
                ),
              ),
              SizedBox(height: 40),
              // TextField cho email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // TextField cho mật khẩu
              TextField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF5025BF),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Thay đổi trạng thái ẩn/hiện mật khẩu
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(color: Color(0xFF5025BF)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Nút đăng nhập
              ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill in all fields")),
                    );
                    return;
                  }

                  // Gọi API đăng nhập từ ApiService
                  ApiService apiService = ApiService();
                  final response = await apiService.login(
                    email: email,
                    password: password,
                  );

                  if (response.containsKey('error')) {
                    // Hiển thị thông báo lỗi nếu có
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['error'])),
                    );
                  } else {
                    // Trích xuất token từ response
                    final String token = response['token'];
                    final Map<String, dynamic> user = response['user'];
// Lưu token
                    TokenService.setToken(response['token']);
                    // Hiển thị thông báo đăng nhập thành công
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login successful!")),
                    );

                    // Điều hướng tới trang tiếp theo và truyền token qua Navigator
                    Navigator.pushReplacementNamed(
                      context,
                      '/home',
                      arguments: {
                        'token': token,
                        'user': user,
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEEE8F5),
                  foregroundColor: Color(0xFF5E35B1),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Sign in"),
              ),
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.fingerprint, size: 50, color: Color(0xFF5025BF)),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don’t have an account? ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(color: Color(0xFF5025BF)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
