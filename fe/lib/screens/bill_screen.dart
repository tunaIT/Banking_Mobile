import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/token_service.dart';
import 'api_service.dart';
import 'bill_payment_screen.dart';

class BillDetail {
  final String userName;
  final String code;
  final String category;
  final String phoneNumber;
  final String address;
  final double amount;
  final double fee;
  final double tax;
  final DateTime fromDate;
  final DateTime toDate;

  BillDetail({
    required this.userName,
    required this.code,
    required this.phoneNumber,
    required this.address,
    required this.category,
    required this.amount,
    required this.fee,
    required this.tax,
    required this.fromDate,
    required this.toDate,
  });

  factory BillDetail.fromJson(dynamic json) {
    return BillDetail(
      userName: json['userName'],
      category: json['category'],
      code: json['code'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      amount: json['amount'].toDouble(),
      fee: json['fee'].toDouble(),
      tax: json['tax'].toDouble(),
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
    );
  }
}

class BillScreen extends StatefulWidget {
  final BillDetail model;

  const BillScreen({super.key, required this.model});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {

  String? _selectedAccount;
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _fetchPayBillCheck() async {
    try {
      final token = TokenService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }
      Uri uri =
      Uri.parse('${ApiService().baseUrl}/bill/${widget.model.code}/pay');
      print(uri.toString());
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful!'),
            duration: Duration(seconds: 2), // Thời gian hiển thị message
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
              const  BillPaymentScreen(),
          ),
        );
        print('Response data success'); // Xử lý thêm nếu cần
      } else {
        print('Response data fail');
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment error!'),
              duration: Duration(seconds: 2), // Thời gian hiển thị message
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
      });
    } finally {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text("${widget.model.category} bill"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.grey[50],
              child: Column(
                children: [
                  // TODO: Replace with actual illustration
                  Image.asset(
                    'lib/images/payment_illustration.png',
                    height: 200,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildInfoSection(),
                  const SizedBox(height: 24),
                  _buildPaymentSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
        ),
        const SizedBox(height: 20),
        // const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            _fetchPayBillCheck();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Pay now',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Name', '${widget.model.userName}'),
            const SizedBox(height: 16),
            _buildInfoRow('Address', '${widget.model.address}'),
            const SizedBox(height: 16),
            _buildInfoRow('Phone number', '${widget.model.phoneNumber}'),
            const SizedBox(height: 16),
            _buildInfoRow('Code', '${widget.model.code}'),
            const SizedBox(height: 16),
            _buildInfoRow('From', '${widget.model.fromDate}'),
            const SizedBox(height: 16),
            _buildInfoRow('To', '${widget.model.toDate}'),
            const SizedBox(height: 24),
            _buildPriceRow('Internet fee', widget.model.amount),
            const SizedBox(height: 16),
            _buildPriceRow('Tax', widget.model.fee),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            _buildTotalRow(60),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        Text(
          '\$$amount',
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TOTAL',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "\$${widget.model.amount + widget.model.fee}",
          style: const TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
