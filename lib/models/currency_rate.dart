class CurrencyRate {
  final String currency;
  final double rate;

  CurrencyRate({required this.currency, required this.rate});

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      currency: json.keys.first,
      rate: json.values.first.toDouble(),
    );
  }
}
