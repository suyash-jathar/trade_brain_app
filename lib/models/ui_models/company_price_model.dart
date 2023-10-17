
class StockQuote {
  final String symbol;
  final double price;
  final DateTime timestamp;

  StockQuote(this.symbol, this.price, this.timestamp);

  factory StockQuote.fromJson(Map<String, dynamic> json) {
    return StockQuote(
      json['01. symbol'],
      double.parse(json['05. price']),
      DateTime.parse(json['07. latest trading day'],),
    );
  }
}
