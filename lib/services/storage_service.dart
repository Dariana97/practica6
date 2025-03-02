import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversion_history.dart';

class StorageService {
  static Future<void> saveConversion(ConversionHistory conversion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("history") ?? [];
    history.add(jsonEncode(conversion.toJson()));
    await prefs.setStringList("history", history);
  }

  static Future<List<ConversionHistory>> getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("history") ?? [];
    return history
        .map((item) => ConversionHistory.fromJson(jsonDecode(item)))
        .toList();
  }
}
