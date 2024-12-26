import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exchange Rate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExchangeRatePage(),
    );
  }
}

class ExchangeRatePage extends StatefulWidget {
  const ExchangeRatePage({super.key});

  @override
  State<ExchangeRatePage> createState() => _ExchangeRatePageState();
}

class _ExchangeRatePageState extends State<ExchangeRatePage> {
  // Danh sách tỷ giá
  final List<Map<String, dynamic>> _exchangeRates = [
    {
      'country': 'Vietnam',
      'flag': 'lib/images/flag_vietnam.png',
      'buy': '1.403',
      'sell': '1.746',
    },
    {
      'country': 'Nicaragua',
      'flag': 'lib/images/flag_nicaragua.png',
      'buy': '9.123',
      'sell': '12.09',
    },
    {
      'country': 'Korea',
      'flag': 'lib/images/flag_korea.png',
      'buy': '3.704',
      'sell': '5.151',
    },
    {
      'country': 'Russia',
      'flag': 'lib/images/flag_russia.png',
      'buy': '116.0',
      'sell': '144.4',
    },
    {
      'country': 'China',
      'flag': 'lib/images/flag_china.png',
      'buy': '1.725',
      'sell': '2.234',
    },
    {
      'country': 'Portuguese',
      'flag': 'lib/images/flag_portuguese.png',
      'buy': '1.403',
      'sell': '1.746',
    },
    {
      'country': 'French',
      'flag': 'lib/images/flag_french.png',
      'buy': '23.45',
      'sell': '34.56',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Exchange Rate',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(flex: 3, child: Text('Country', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Buy', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Sell', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          // Danh sách tỷ giá
          Expanded(
            child: ListView.builder(
              itemCount: _exchangeRates.length,
              itemBuilder: (context, index) {
                final rate = _exchangeRates[index];
                return _buildExchangeRateTile(
                  context,
                  rate['country'],
                  rate['flag'],
                  rate['buy'],
                  rate['sell'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRateTile(
      BuildContext context,
      String country,
      String flagAssetPath,
      String buy,
      String sell,
      ) {
    return Column(
      children: [
        ListTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(
              flagAssetPath,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(country, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(buy),
                Text(sell),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
