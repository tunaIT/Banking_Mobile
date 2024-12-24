import 'package:flutter/material.dart';
import '../widgets/bill_item.dart';

class BillPaymentScreen extends StatelessWidget {
  const BillPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Pay the bill'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: const [
          BillItem(
            title: 'Electric bill',
            subtitle: 'Pay electric bill this month',
            icon: Icons.electric_bolt,
            iconColor: Colors.orange,
          ),
          BillItem(
            title: 'Water bill',
            subtitle: 'Pay water bill this month',
            icon: Icons.water_drop,
            iconColor: Colors.blue,
          ),
          BillItem(
            title: 'Mobile bill',
            subtitle: 'Pay mobile bill this month',
            icon: Icons.phone_android,
            iconColor: Colors.purple,
          ),
          BillItem(
            title: 'Internet bill',
            subtitle: 'Pay internet bill this month',
            icon: Icons.wifi,
            iconColor: Colors.pink,
          ),
        ],
      ),
    );
  }
}
