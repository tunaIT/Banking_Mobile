import 'dart:convert';
import 'package:fe/screens/bill_screen.dart';
import 'package:flutter/material.dart';
import '../services/token_service.dart';
import 'api_service.dart';
import 'package:http/http.dart' as http;

class PayBillScreen extends StatefulWidget {
  const PayBillScreen({super.key});

  @override
  State<PayBillScreen> createState() => _PayBillScreenState();
}

class _PayBillScreenState extends State<PayBillScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCompany;
  final _billCodeController = TextEditingController();
  bool _isLoading = false;
  String? _statusMessage;

  @override
  void dispose() {
    _billCodeController.dispose();
    super.dispose();
  }

  void _handleCheck() {
    // TODO: Handle check logic
    print('Company: $_selectedCompany');
    print('Bill Code: ${_billCodeController.text}');
    _fetchPayBillCheck();
  }

  Future<void> _fetchPayBillCheck() async {
    try {
      final token = TokenService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }
      Uri uri =
          Uri.parse('${ApiService().baseUrl}/bill/${_billCodeController.text}');
      print(uri.toString());
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        print(jsonData["userName"]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BillScreen(model: BillDetail.fromJson(jsonData)),
          ),
        );
        print('Response data success'); // Xử lý thêm nếu cần
      } else {
        print('Response data fail');
        setState(() {
          _statusMessage =
              'Failed to retrieve bill information. Error: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
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
        title: const Text('Pay the bill'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Type internet bill code',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _billCodeController,
                decoration: InputDecoration(
                  hintText: 'Bill code',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bill code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Please enter the correct bill code to check information.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleCheck,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Check',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
