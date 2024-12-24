import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF2136D6),
        elevation: 0,
        title: Text("Sign up"), foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
              TextField(
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "By creating an account you agree to our ",
                        children: [
                          TextSpan(
                            text: "Term and Conditions",
                            style: TextStyle(color: Color(0xFF5025BF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEEE8F5),
                  foregroundColor: Color(0xFF5025BF),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Sign up"),
              ),
              SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {},
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
