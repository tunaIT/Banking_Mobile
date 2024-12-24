import 'package:flutter/material.dart';
import 'screens/payment_history_screen.dart';
import 'screens/payment_detail_screen.dart';
import 'screens/pay_bill_screen.dart';
import 'screens/internet_bill_screen.dart';
import 'screens/transfer_screen.dart';
import 'screens/confirm_transfer_screen.dart';
import 'screens/transaction_report_screen.dart';
import 'screens/bill_payment_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banking App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          children: [
            _buildNavigationButton(
              context,
              'Payment History',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentHistoryScreen(),
                ),
              ),
            ),
            _buildNavigationButton(
              context,
              'Payment Detail',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentDetailScreen(),
                ),
              ),
            ),
            _buildNavigationButton(
              context,
              'Pay Bill',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PayBillScreen(),
                ),
              ),
            ),
            _buildNavigationButton(
              context,
              'Internet Bill',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InternetBillScreen(),
                ),
              ),
            ),
            _buildNavigationButton(
              context,
              'Transfer',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransferScreen(),
                ),
              ),
            ),
            _buildNavigationButton(
              context,
              'Confirm Transfer',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfirmTransferScreen(),
                ),
              ),
            ),
            _buildNavigationButton(
              context,
              'Transaction Report',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionReportScreen(),
                ),
              ),
            ),
            _buildNavigationButton(
              context,
              'Bill Payment',
              () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BillPaymentScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String title,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
