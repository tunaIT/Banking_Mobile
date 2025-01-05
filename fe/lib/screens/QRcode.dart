import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fe/services/api_service.dart'; // Import lớp ApiService

class QRcodeScreen extends StatelessWidget {
  final ApiService apiService; // Instance của ApiService

  const QRcodeScreen({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    // Nhận token từ arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final String? token = args?['token'];

    if (token == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("QR Code"),
        ),
        body: const Center(
          child: Text(
            "Token not provided!",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2136D6),
        elevation: 0,
        title: const Text("QR Code"),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: FutureBuilder<Uint8List?>(
          future: apiService.fetchQrCode(token), // Gọi phương thức từ ApiService
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Hiển thị khi đang tải
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Text(
                "Failed to load QR Code.",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ); // Hiển thị khi lỗi
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2136D6),
                        width: 3,
                      ),
                    ),
                    child: Image.memory(snapshot.data!), // Hiển thị QR code
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Scan this QR code",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
