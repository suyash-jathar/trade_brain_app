import 'package:hive/hive.dart';

part 'companypricemodel.g.dart';

@HiveType(typeId: 1)
class CompanyPriceModel {
  @HiveField(0)
  final String symbol;
  @HiveField(1)
  final double price;

  CompanyPriceModel({required this.symbol, required this.price});
}
