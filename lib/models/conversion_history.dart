class ConversionHistory {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double result;
  final String date;

  ConversionHistory({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.result,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      "from": fromCurrency,
      "to": toCurrency,
      "amount": amount,
      "result": result,
      "date": date,
    };
  }

  factory ConversionHistory.fromJson(Map<String, dynamic> json) {
    return ConversionHistory(
      fromCurrency: json["from"],
      toCurrency: json["to"],
      amount: json["amount"],
      result: json["result"],
      date: json["date"],
    );
  }
}
