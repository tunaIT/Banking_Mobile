import 'package:flutter/material.dart';
import 'pay_bill_screen.dart';
import 'payment_history_screen.dart'; // Import màn hình lịch sử thanh toán
import '../screens/bill_item.dart';

class BillPaymentScreen extends StatelessWidget {
  const BillPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Pay the bill'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          BillItem(
            title: 'Electric bill',
            subtitle: 'Pay electric bill this month',
            icon: Icons.electric_bolt,
            iconColor: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PayBillScreen(),
                ),
              );
            },
          ),
          BillItem(
            title: 'Water bill',
            subtitle: 'Pay water bill this month',
            icon: Icons.water_drop,
            iconColor: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PayBillScreen(),
                ),
              );
            },
          ),
          BillItem(
            title: 'Mobile bill',
            subtitle: 'Pay mobile bill this month',
            icon: Icons.phone_android,
            iconColor: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PayBillScreen(),
                ),
              );
            },
          ),
          BillItem(
            title: 'Internet bill',
            subtitle: 'Pay internet bill this month',
            icon: Icons.wifi,
            iconColor: Colors.pink,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PayBillScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
