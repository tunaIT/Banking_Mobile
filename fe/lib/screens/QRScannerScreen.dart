import 'package:fe/screens/api_service.dart';
import 'package:flutter/material.dart';
import 'payment_detail_screen.dart'; // Nếu nằm trong cùng một thư mục hoặc thư mục cha
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/token_service.dart'; // Đảm bảo đường dẫn đúng nếu thư mục con

import 'package:flutter/material.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          final Barcode? barcode = barcodes.isNotEmpty ? barcodes.first : null;

          if (barcode != null && barcode.rawValue != null) {
            final String result = barcode.rawValue!;
            Navigator.pop(context, result); // Trả về dữ liệu quét được
          }
        },
      ),
    );
  }
}
