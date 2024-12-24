import 'package:flutter/material.dart';

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

class TransactionReportScreen extends StatelessWidget {
  const TransactionReportScreen({super.key});

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
                  const Text(
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
