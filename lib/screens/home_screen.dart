// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trade_brain_app/models/ui_models/company_model.dart';
import 'package:trade_brain_app/services/api_service.dart';
import 'package:trade_brain_app/utils/utils.dart';
import '../models/hive_models/companyhivemodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCompaniesFromHive();
  }

  final _companyBox = Hive.openBox<CompanyHiveModel>('companies');

  Future<void> _loadCompaniesFromHive() async {
    final box = await _companyBox;
  }

  Future<void> _saveCompanyToHive(CompanyHiveModel company) async {
    final box = await _companyBox;
    box.put(company.symbol, company);
  }

  List<CompanyModel> stocks = [];
  Map<String, double> closePrices =
      {}; // Use a map to store stock prices by symbol
  bool isLoading = false;
  List<CompanyModel> suggestions = [];
  Future<void> fetchCompanyData(String companyName) async {
    setState(() {
      isLoading = true;
      suggestions.clear(); // Clear suggestions when fetching new data
    });

    try {
      final data = await ApiService.fetchCompanyData(companyName);
      setState(() {
        stocks = (data['bestMatches'] as List)
            .map((entry) => CompanyModel.fromJson(entry))
            .toList();
      });

      for (final company in stocks) {
        await fetchStockData(company.symbol);
      }
    } catch (e) {
      // Handle API call errors here
      print('Failed to fetch data: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchStockData(String symbol) async {
    final quote = await ApiService.getStockQuote(symbol);
    setState(() {
      closePrices[symbol] = quote.price;
    });
  }

  void updateSuggestions(String input) {
    if (input.isEmpty) {
      suggestions.clear();
    } else {
      suggestions = stocks
          .where((company) =>
              company.name.toLowerCase().contains(input.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      color: Colors.white,
                      child: Autocomplete(
                        optionsBuilder: (TextEditingValue textEditingValue) {

                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          } else {
                            fetchCompanyData(textEditingValue.text);
                            Future.delayed(Duration(seconds: 1));
                            return stocks
                                .where((company) => company.name
                                    .toLowerCase()
                                    .contains(
                                        textEditingValue.text.toLowerCase()))
                                .map((company) => company.name)
                                .toList();
                          }
                        },
                        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              hintText: 'Enter a Company Name, ex. tata, ibm, etc',
                              hintStyle: TextStyle(fontSize: 13)
                            ),
                          );
                        },
                        onSelected: (String selection) {
                          print('You just selected $selection');
                        },
                      ),
                    ),
                  ),
                ),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      fetchCompanyData(_searchController.text);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: stocks.length > 4 ? 4 : stocks.length, //Limited to four because api limit is 5 calls per minute
                    itemBuilder: (context, index) {
                      final company = stocks[index];
                      final closePrice = closePrices[company.symbol];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: ListTile(
                          title: Text(company.name),
                          subtitle: Text(
                            closePrice != null
                                ? 'Stock Price :${company.currency == 'USD' ? '\$' : 'Rs'} ${closePrice.toStringAsFixed(2)}'
                                : 'Fetching...',
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _saveCompanyToHive(
                                CompanyHiveModel(
                                  name: company.name,
                                  currency: company.currency,
                                  symbol: company.symbol,
                                  price: closePrice.toString(),
                                ),
                              );
                              showSnackBar(context, 'Company Deatails added to Wishlist Section !!!!',Colors.green);
                            },
                            icon: Icon(
                              Icons.add_circle_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
