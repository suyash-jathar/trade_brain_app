import 'package:hive/hive.dart';

part 'companyhivemodel.g.dart';

@HiveType(typeId: 0)
class CompanyHiveModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String currency;
  @HiveField(2)
  final String symbol;
  @HiveField(3)
  final String price;

  CompanyHiveModel({required this.name, required this.currency, required this.symbol, required this.price});

  CompanyHiveModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        currency = json['currency'], 
        symbol = json['symbol'],
        price = json['price']
        ;
}