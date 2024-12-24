import 'package:flutter/material.dart';

class InternetBillScreen extends StatefulWidget {
  const InternetBillScreen({super.key});

  @override
  State<InternetBillScreen> createState() => _InternetBillScreenState();
}

class _InternetBillScreenState extends State<InternetBillScreen> {
  String? _selectedAccount;
  final _otpController = TextEditingController();
  final List<String> _accounts = [
    'Account 1 (**** 1234)',
    'Account 2 (**** 5678)',
    'Credit Card (**** 9012)',
  ];

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Internet bill'),
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
                  Text(
                    '01/10/2019 - 01/11/2019',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All the Bills',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedAccount,
              hint: const Text(
                'Choose account/ card',
                style: TextStyle(color: Colors.grey),
              ),
              isExpanded: true,
              items: _accounts.map((String account) {
                return DropdownMenuItem<String>(
                  value: account,
                  child: Text(account),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAccount = newValue;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Get OTP to verify transaction',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _otpController,
                decoration: InputDecoration(
                  hintText: 'OTP',
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
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: () {
                // TODO: Handle resend OTP
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[100],
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Resend',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            // TODO: Handle payment
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
            _buildInfoRow('Name', 'Jackson Maine'),
            const SizedBox(height: 16),
            _buildInfoRow('Address', '403 East 4th Street,\nSanta Ana'),
            const SizedBox(height: 16),
            _buildInfoRow('Phone number', '+8424599721'),
            const SizedBox(height: 16),
            _buildInfoRow('Code', '#2343543'),
            const SizedBox(height: 16),
            _buildInfoRow('From', '01/10/2019'),
            const SizedBox(height: 16),
            _buildInfoRow('To', '01/11/2019'),
            const SizedBox(height: 24),
            _buildPriceRow('Internet fee', 50),
            const SizedBox(height: 16),
            _buildPriceRow('Tax', 10),
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
          '\$$total',
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
