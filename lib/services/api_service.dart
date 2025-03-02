import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://api.frankfurter.app";

  // Obtener todas las monedas disponibles
  static Future<List<String>> getCurrencies() async {
    final response = await http.get(Uri.parse("$baseUrl/currencies"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data.keys);
    } else {
      throw Exception("Error al cargar monedas disponibles");
    }
  }

  static Future<double> convertCurrency(
      String from, String to, double amount, String date) async {
    final response = await http.get(Uri.parse("$baseUrl/$date?from=$from&to=$to&amount=$amount"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["rates"][to];
    } else {
      throw Exception("Error al obtener la tasa de conversión");
    }
  }
}
