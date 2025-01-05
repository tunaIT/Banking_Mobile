import 'package:fe/screens/transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR'),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            print(barcode.rawValue);
            if (barcode.rawValue!.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TransferScreen(cardNumber: barcode.rawValue.toString()),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
