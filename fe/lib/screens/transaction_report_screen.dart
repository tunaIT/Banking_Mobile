import 'dart:convert';

import 'package:fe/screens/api_service.dart';
import 'package:fe/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Transaction {
  final int id;
  final String fromUser;
  final String toUser;
  final double amount;
  final double fee;
  final String created;

  Transaction({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.amount,
    required this.fee,
    required this.created,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      fromUser: json['fromUser'],
      toUser: json['toUser'],
      amount: json['amount'].toDouble(),
      fee: json['fee'],
      created: json['created'],
    );
  }
}

class TransactionReportScreen extends StatefulWidget {
  const TransactionReportScreen({super.key});

  @override
  State<TransactionReportScreen> createState() => _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen> {
  List<Transaction> _allTransition = [];
  @override
  void initState() {
    super.initState();
    _fetchTransactionReport();
  }

  Future<void> _fetchTransactionReport() async {
    try {
      final token = TokenService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('${ApiService().baseUrl}/transition/current'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _allTransition =
              jsonData.map((data) => Transaction.fromJson(data)).toList();
          // _isLoading = false;
        });
      } else {
        throw Exception('Failed to load payment history');
      }
    } catch (e) {
      // setState(() {
      //   _isLoading = false;
      // });
      print('Error fetching payment history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction report',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCreditCard(),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 1.586, // Standard credit card ratio
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A237E), // Deep Purple
                Color(0xFF2196F3), // Blue
              ],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Smith',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Amazon Platinium',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '4756 •••• •••• 9018',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Image.asset(
                        'lib/images/visa_logo.png',
                        height: 40,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$3,469.52',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildTransactionGroup('Today', todayTransactions),
          const SizedBox(height: 24),
          _buildTransactionGroup('Yesterday', _allTransition),
        ],
      ),
    );
  }

  Widget _buildTransactionGroup(String title, List<Transaction> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...transactions
            .map((transaction) => _buildTransactionItem(transaction)),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isPositive = transaction.amount > 0;
    final amountColor = isPositive ? Colors.blue : Colors.red;
    final amountPrefix = isPositive ? '+ ' : '- ';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              // color: transaction.iconBackgroundColor,
              color: const Color(0xFF0890FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.attach_money_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.fromUser,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (transaction.toUser != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    transaction.created,
                    style: TextStyle(

                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '$amountPrefix\$${transaction.amount.abs()}',
            style: TextStyle(
              color: amountColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
