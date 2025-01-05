import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiUrl =
      "https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_ZAQJFYT8lTFNWTTPtKpQLw329ifSJjhzALPjLHQB";

  Future<Map<String, dynamic>> fetchRates() async {
    final response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}
