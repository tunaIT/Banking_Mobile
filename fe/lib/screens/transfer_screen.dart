import 'dart:convert';

import 'package:fe/screens/home.dart';
import 'package:fe/screens/transaction_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../services/token_service.dart';

class TransferScreen extends StatefulWidget {
  final String? cardNumber;

  const TransferScreen({super.key, this.cardNumber});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  String? _selectedBank;
  String? _selectedBranch;
  bool _saveToDirectory = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  final List<String> _banks = ['Bank A', 'Bank B', 'Bank C'];
  final List<String> _branches = ['Branch 1', 'Branch 2', 'Branch 3'];

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _amountController.dispose();
    _noteController.dispose();
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
        title: const Text('Transfer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAccountSection(),
                const SizedBox(height: 24),
                _buildTransactionTypeSection(),
                const SizedBox(height: 24),
                _buildBeneficiarySection(),
                const SizedBox(height: 24),
                _buildTransferForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchTransfer() async {
    try {
      final token = TokenService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }
      var bodyEncoded = json.encode({
        "receiver": _cardNumberController.text,
        "amount": int.parse(_amountController.text)
      });
      Uri uri = Uri.parse('${ApiService().baseUrl}/user/tranfer');
      print(uri.toString());
      final response = await http.post(uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: bodyEncoded);
      print(response.statusCode);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer successful!'),
            duration: Duration(seconds: 2), // Thời gian hiển thị message
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
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
      setState(() {});
    } finally {
      setState(() {});
    }
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose account/ card',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'VISA **** **** **** 1234',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Available balance : 10,000\$',
          style: TextStyle(
            color: Colors.blue[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose transaction',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTransactionTypeCard(
                icon: Icons.credit_card,
                title: 'Transfer via\ncard number',
                isSelected: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTransactionTypeCard(
                icon: Icons.account_balance,
                title: 'Transfer to\nthe same bank',
                isSelected: true,
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionTypeCard({
    required IconData icon,
    required String title,
    required bool isSelected,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? color ?? Colors.grey[200] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey[600],
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontSize: 14,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Choose beneficiary',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Handle find beneficiary
              },
              child: const Text(
                'Find beneficiary',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildAddBeneficiaryButton(),
              const SizedBox(width: 16),
              _buildBeneficiaryAvatar(
                name: 'Emma',
                imageUrl: 'lib/images/emma.png',
                isSelected: true,
              ),
              const SizedBox(width: 16),
              _buildBeneficiaryAvatar(
                name: 'Justin',
                imageUrl: 'lib/images/justin.png',
                isSelected: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddBeneficiaryButton() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add new',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBeneficiaryAvatar({
    required String name,
    required String imageUrl,
    required bool isSelected,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                isSelected ? Border.all(color: Colors.blue, width: 2) : null,
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTransferForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // _buildDropdownField(
        //   value: _selectedBank,
        //   items: _banks,
        //   hint: 'Choose bank',
        //   onChanged: (value) => setState(() => _selectedBank = value),
        // ),
        // const SizedBox(height: 16),
        // _buildDropdownField(
        //   value: _selectedBranch,
        //   items: _branches,
        //   hint: 'Choose branch',
        //   onChanged: (value) => setState(() => _selectedBranch = value),
        // ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _nameController,
          hint: 'Name',
        ),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _cardNumberController,
            hint: 'Card number',
            text: widget.cardNumber),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _amountController,
          hint: 'Amount',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _noteController,
          hint: 'Note',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: _saveToDirectory,
              onChanged: (value) {
                setState(() {
                  _saveToDirectory = value ?? false;
                });
              },
            ),
            const Text(
              'Save to directory of beneficiary',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            _fetchTransfer();
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
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.grey),
          ),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? text,
  }) {
    if (text != null) {
      controller.text = text;
    }
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
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
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
