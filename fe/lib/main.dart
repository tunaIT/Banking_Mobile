import 'package:flutter/material.dart';

import 'screens/sign_in.dart';
import 'screens/sign_up.dart';
import 'screens/forgot_password.dart';
import 'screens/setting.dart';
import 'screens/home.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2136D6)),
        useMaterial3: true,
      ),
      home: SignInScreen(), // Màn hình chính
      routes: {
        '/sign-in': (context) => SignInScreen(),
        '/sign-up': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/setting': (context) => SettingsScreen(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
