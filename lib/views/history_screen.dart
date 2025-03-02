import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/conversion_history.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ConversionHistory> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    List<ConversionHistory> storedHistory = await StorageService.getHistory();
    setState(() {
      history = storedHistory.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historial de Conversión"), centerTitle: true),
      body: history.isEmpty
          ? Center(child: Text("No hay historial disponible"))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(Icons.monetization_on, color: Colors.green),
                    title: Text("${item.amount} ${item.fromCurrency} → ${item.result} ${item.toCurrency}"),
                    subtitle: Text("Fecha: ${item.date}"),
                  ),
                );
              },
            ),
    );
  }
}
