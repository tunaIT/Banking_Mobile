import 'package:fe/screens/api_service.dart';
import 'package:flutter/material.dart';
import 'payment_detail_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/token_service.dart';

class PaymentHistory {
  final int id;
  final String forUser;
  final String category;
  final double amount;
  final String status;
  final DateTime created;

  PaymentHistory({
    required this.id,
    required this.forUser,
    required this.category,
    required this.amount,
    required this.status,
    required this.created,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'],
      forUser: json['forUser'],
      category: json['category'],
      amount: json['amount'].toDouble(),
      status: json['status'],
      created: DateTime.parse(json['created']),
    );
  }
}

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Electric', 'Water', 'Mobile', 'Internet'];
  List<PaymentHistory> _allPayments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _fetchPaymentHistory();
  }

  Future<void> _fetchPaymentHistory() async {
    try {
      final token = TokenService.getToken();
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('${ApiService().baseUrl}/payment/search'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _allPayments =
              jsonData.map((data) => PaymentHistory.fromJson(data)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load payment history');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching payment history: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        title: const Text('Payment history'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((String tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: _tabs.map((String tab) {
          return PaymentHistoryList(
            payments: _allPayments
                .where((payment) =>
            payment.category.toLowerCase() == tab.toLowerCase())
                .toList(),
          );
        }).toList(),
      ),
    );
  }
}

class PaymentHistoryList extends StatelessWidget {
  final List<PaymentHistory> payments;

  const PaymentHistoryList({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const Center(child: Text('No payment history found'));
    }

    return ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentDetailScreen(model: payment,),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment ${payment.id}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Status: ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        payment.status,
                        style: TextStyle(
                          color: payment.status == 'completed'
                              ? Colors.green
                              : payment.status == 'pending'
                              ? Colors.orange
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'User: ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        payment.forUser,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount: \$${payment.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${payment.created.day}/${payment.created.month}/${payment.created.year}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
