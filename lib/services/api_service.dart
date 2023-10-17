import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ui_models/company_price_model.dart';

class ApiService {
  static const String _baseUrl = 'https://www.alphavantage.co/query';
  static const String _apiKey = 'ASWK9G6MWSOTQDL5';

  static Future<Map<String, dynamic>> fetchCompanyData(
      String companyName) async {
    final url = '$_baseUrl?function=SYMBOL_SEARCH&keywords=$companyName&apikey=$_apiKey';
    final response = await http.get(Uri.parse(url));
    print(url);
    print(response.body.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    }
    else {
      throw Exception('Failed to fetch data');
    }
  }

  static Future<StockQuote> getStockQuote(String symbol) async {
    final url = Uri.parse('https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return StockQuote.fromJson(data['Global Quote']);
    } else {
      throw Exception('Failed to load stock data');
    }
  }
}
