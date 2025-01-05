import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Đảm bảo import đúng ApiService
import 'sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService apiService = ApiService(); // Khởi tạo ApiService
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isChecked = false;

  void _signUp() async {
    setState(() {
      _isLoading = true; // Đặt trạng thái loading
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      setState(() {
        _isLoading = false; // Đặt trạng thái không loading khi có lỗi
      });
      return;
    }

    final response = await apiService.register(
      name: name,
      email: email,
      password: password,
    );

    setState(() {
      _isLoading = false; // Kết thúc loading
    });

    if (response.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['error'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign up successful!")),
      );
      Navigator.pop(context); // Quay lại màn hình trước đó
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF2136D6),
        elevation: 0,
        title: Text("Sign up"),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SignInScreen(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Welcome to us,",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F1DCD),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Hello there, create New account",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 40),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFEEE8F5),
                  child: Icon(Icons.person, size: 50, color: Color(0xFF5025BF)),
                ),
              ),
              SizedBox(height: 40),
              // Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Checkbox for Terms and Conditions
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "By creating an account you agree to our ",
                        children: [
                          TextSpan(
                            text: "Terms and Conditions",
                            style: TextStyle(color: Color(0xFF5025BF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Sign Up Button
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                  if (!_isChecked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                        Text("Please agree to the Terms and Conditions"),
                      ),
                    );
                    return;
                  }
                  _signUp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEEE8F5),
                  foregroundColor: Color(0xFF5025BF),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Color(0xFF5025BF))
                    : Text("Sign up"),
              ),
              SizedBox(height: 20),
              // Sign In link
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Text(
                    "Have an account? Sign In",
                    style: TextStyle(color: Color(0xFF5025BF)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
