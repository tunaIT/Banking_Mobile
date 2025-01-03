import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transaction {
  final String title;
  final String? subtitle;
  final double amount;
  final IconData icon;
  final Color iconBackgroundColor;
  final bool isSuccess;

  Transaction({
    required this.title,
    this.subtitle,
    required this.amount,
    required this.icon,
    required this.iconBackgroundColor,
    this.isSuccess = true,
  });
}

// Lấy thông tin người dùng
Future<Map<String, dynamic>> getUserInfo(String token) async {
  final String baseUrl = "http://10.0.2.2:8081";
  final url = Uri.parse(
      '$baseUrl/user/current-user'); // API endpoint để lấy thông tin người dùng

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Gửi token trong header
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Trả về thông tin người dùng
    } else {
      throw Exception('Failed to fetch user info');
    }
  } catch (e) {
    return {'error': 'An error occurred: $e'};
  }
}

class TransactionReportScreen extends StatefulWidget {
  const TransactionReportScreen({super.key});

  @override
  State<TransactionReportScreen> createState() => _TransactionReportScreen();
}

class _TransactionReportScreen extends State<TransactionReportScreen> {
  final ApiService apiService = ApiService();
  String userName = 'Loading...'; // Tên mặc định trước khi tải
  Map<String, dynamic> userInfo =
  {}; // Khai báo biến userInfo để lưu thông tin người dùng

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('token')) {
      final token = arguments['token'] as String; // Lấy token từ arguments
      fetchUserName(token);
    } else {
      setState(() {
        userName = 'Token not found';
      });
    }
  }
  void fetchUserName(String token) async {
    try {
      // Gọi API để lấy thông tin người dùng
      final fetchedUserInfo =
      await getUserInfo(token); // Lấy thông tin người dùng từ API

      setState(() {
        userInfo = fetchedUserInfo; // Cập nhật userInfo toàn cục
        if (userInfo.containsKey('name')) {
          userName = userInfo['name']; // Cập nhật tên người dùng
        } else {
          userName = 'Unknown User'; // Gán giá trị mặc định nếu không có tên
        }
      });
    } catch (e) {
      // Xử lý lỗi (ví dụ: lỗi mạng, token không hợp lệ)
      debugPrint('Error fetching user info: $e');
      setState(() {
        userName = 'Error loading name'; // Hiển thị lỗi cho người dùng
      });
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
                    userInfo.containsKey('name')
                        ? userInfo['name']
                        : 'Unknown User',
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
                      Text(
                        userInfo.containsKey('cardNumber')
                            ? '**** **** **** ${userInfo['cardNumber'].substring(userInfo['cardNumber'].length - 4)}'
                            : '**** **** **** 0000',
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
                  Text(
                    userInfo.containsKey('balance')
                        ? '\$${userInfo['balance']}'
                        : '\$0.00',
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
    final todayTransactions = [
      Transaction(
        title: 'Water Bill',
        subtitle: 'Unsuccessfully',
        amount: -280,
        icon: Icons.water_drop,
        iconBackgroundColor: Colors.blue,
        isSuccess: false,
      ),
    ];

    final yesterdayTransactions = [
      Transaction(
        title: 'Income: Salary Oct',
        amount: 1200,
        icon: Icons.account_balance_wallet,
        iconBackgroundColor: Colors.pink,
      ),
      Transaction(
        title: 'Electric Bill',
        subtitle: 'Successfully',
        amount: -480,
        icon: Icons.electric_bolt,
        iconBackgroundColor: Colors.blue,
      ),
      Transaction(
        title: 'Income: Jane transfers',
        amount: 500,
        icon: Icons.swap_horiz,
        iconBackgroundColor: Colors.orange,
      ),
      Transaction(
        title: 'Internet Bill',
        subtitle: 'Successfully',
        amount: -100,
        icon: Icons.wifi,
        iconBackgroundColor: Colors.teal,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransactionGroup('Today', todayTransactions),
          const SizedBox(height: 24),
          _buildTransactionGroup('Yesterday', yesterdayTransactions),
        ],
      ),
    );
  }

  Widget _buildTransactionGroup(String title, List<Transaction> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
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
              color: transaction.iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
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
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (transaction.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    transaction.subtitle!,
                    style: TextStyle(
                      color: transaction.isSuccess ? Colors.grey : Colors.red,
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
