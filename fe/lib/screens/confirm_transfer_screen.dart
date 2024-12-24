import 'package:flutter/material.dart';

class ConfirmTransferScreen extends StatefulWidget {
  const ConfirmTransferScreen({super.key});

  @override
  State<ConfirmTransferScreen> createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen> {
  final _otpController = TextEditingController();

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
        title: const Text('Confirm'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Confirm transaction information',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              _buildTransactionInfo(),
              const SizedBox(height: 24),
              _buildOTPSection(),
              const SizedBox(height: 24),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionInfo() {
    return Column(
      children: [
        _buildInfoField('From', '**** **** 6789'),
        const SizedBox(height: 16),
        _buildInfoField('To', 'Amanda'),
        const SizedBox(height: 16),
        _buildInfoField('Beneficiary bank', 'US bank'),
        const SizedBox(height: 16),
        _buildInfoField('Card number', '0123456789'),
        const SizedBox(height: 16),
        _buildInfoField('Transaction fee', '10\$'),
        const SizedBox(height: 16),
        _buildInfoField('Note', 'From Jimy'),
        const SizedBox(height: 16),
        _buildInfoField('Amount', '\$1000', isAmount: true),
      ],
    );
  }

  Widget _buildInfoField(String label, String value, {bool isAmount = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isAmount ? FontWeight.bold : null,
              color: isAmount ? Colors.black : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOTPSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: () {
        // TODO: Handle confirm
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple[100],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Confirm',
        style: TextStyle(
          color: Colors.deepPurple,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
