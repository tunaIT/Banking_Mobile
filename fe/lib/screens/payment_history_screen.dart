import 'package:flutter/material.dart';
import 'payment_detail_screen.dart';

class PaymentHistory {
  final String month;
  final String status;
  final double amount;
  final String date;
  final String? company;

  PaymentHistory({
    required this.month,
    required this.status,
    required this.amount,
    required this.date,
    this.company,
  });
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((String tab) {
          return PaymentHistoryList(type: tab);
        }).toList(),
      ),
    );
  }
}

class PaymentHistoryList extends StatelessWidget {
  final String type;

  const PaymentHistoryList({super.key, required this.type});

  List<PaymentHistory> _getPaymentHistory() {
    if (type == 'Electric') {
      return [
        PaymentHistory(
            month: 'October',
            status: 'Unsuccessfully',
            amount: 480,
            date: '30/10/2019'),
        PaymentHistory(
            month: 'September',
            status: 'Successfully',
            amount: 480,
            date: '30/09/2019'),
        PaymentHistory(
            month: 'August',
            status: 'Successfully',
            amount: 480,
            date: '30/08/2019'),
        PaymentHistory(
            month: 'July',
            status: 'Successfully',
            amount: 480,
            date: '30/07/2019'),
        PaymentHistory(
            month: 'June',
            status: 'Successfully',
            amount: 480,
            date: '30/06/2019'),
        PaymentHistory(
            month: 'May',
            status: 'Successfully',
            amount: 480,
            date: '30/05/2019'),
      ];
    } else if (type == 'Internet') {
      return [
        PaymentHistory(
            month: 'October',
            status: 'Unsuccessfully',
            amount: 50,
            date: '30/10/2019',
            company: 'Capi Telecom'),
        PaymentHistory(
            month: 'September',
            status: 'Successfully',
            amount: 50,
            date: '30/09/2019',
            company: 'Capi Telecom'),
        PaymentHistory(
            month: 'August',
            status: 'Successfully',
            amount: 50,
            date: '30/08/2019',
            company: 'Capi Telecom'),
        PaymentHistory(
            month: 'July',
            status: 'Successfully',
            amount: 50,
            date: '30/07/2019',
            company: 'Capi Telecom'),
        PaymentHistory(
            month: 'June',
            status: 'Successfully',
            amount: 50,
            date: '30/06/2019',
            company: 'Capi Telecom'),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final payments = _getPaymentHistory();
    return ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaymentDetailScreen(),
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
                    payment.month,
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
                          color: payment.status == 'Successfully'
                              ? Colors.blue
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  if (payment.company != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Company: ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          payment.company!,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount: \$${payment.amount.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        payment.date,
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
