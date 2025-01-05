import 'package:flutter/material.dart';
import 'package:fe/services/api_service.dart';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final ApiService _currencyService = ApiService();

  Map<String, dynamic>? _rates;
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _amount = 1.0;
  double? _convertedAmount;

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  Future<void> _fetchRates() async {
    try {
      final rates = await _currencyService.fetchRates();
      setState(() {
        _rates = rates;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load exchange rates: $error')),
      );
    }
  }

  void _convertCurrency() {
    if (_rates != null && _rates!.containsKey(_fromCurrency) && _rates!.containsKey(_toCurrency)) {
      double rate = _rates![_toCurrency] / _rates![_fromCurrency];
      setState(() {
        _convertedAmount = _amount * rate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF2136D6),
          title: Text('Currency Converter'),
          foregroundColor: Colors.white,
      ),
      body: _rates == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 1.0;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _fromCurrency,
                  items: _rates!.keys
                      .map((currency) => DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _fromCurrency = value!;
                    });
                  },
                ),
                Icon(Icons.arrow_forward),
                DropdownButton<String>(
                  value: _toCurrency,
                  items: _rates!.keys
                      .map((currency) => DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _toCurrency = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            if (_convertedAmount != null)
              Text(
                'Converted Amount: ${_convertedAmount!.toStringAsFixed(2)} $_toCurrency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}