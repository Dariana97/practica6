import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../models/conversion_history.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> currencies = [];
  String fromCurrency = "USD";
  String toCurrency = "EUR";
  double amount = 1.0;
  double result = 0.0;
  String selectedDate = "latest";
  TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    amountController.text = amount.toString();
    loadCurrencies();
  }

  void loadCurrencies() async {
    try {
      List<String> currencyList = await ApiService.getCurrencies();
      setState(() {
        currencies = currencyList;
        fromCurrency = currencyList.first;
        toCurrency = currencyList[1];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar monedas")),
      );
    }
  }

  void convertCurrency() async {
    setState(() => isLoading = true);
    try {
      double rate = await ApiService.convertCurrency(fromCurrency, toCurrency, amount, selectedDate);
      setState(() {
        result = rate;
        isLoading = false;
      });

      await StorageService.saveConversion(
        ConversionHistory(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          amount: amount,
          result: result,
          date: selectedDate,
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al obtener la tasa de cambio")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Conversor de Moneda"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Cantidad"),
              onChanged: (value) {
                setState(() {
                  amount = double.tryParse(value) ?? 1.0;
                });
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: fromCurrency,
                    isExpanded: true,
                    items: currencies.map((String currency) {
                      return DropdownMenuItem(value: currency, child: Text(currency));
                    }).toList(),
                    onChanged: (value) => setState(() => fromCurrency = value!),
                  ),
                ),
                Icon(Icons.swap_horiz),
                Expanded(
                  child: DropdownButton<String>(
                    value: toCurrency,
                    isExpanded: true,
                    items: currencies.map((String currency) {
                      return DropdownMenuItem(value: currency, child: Text(currency));
                    }).toList(),
                    onChanged: (value) => setState(() => toCurrency = value!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: "Fecha (YYYY-MM-DD)"),
              onChanged: (value) {
                setState(() {
                  selectedDate = value.isEmpty ? "latest" : value;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: convertCurrency,
              child: isLoading ? CircularProgressIndicator() : Text("Convertir"),
            ),
            SizedBox(height: 10),
            Text("Resultado: $result $toCurrency", textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => HistoryScreen())),
              child: Text("Ver Historial"),
            ),
          ],
        ),
      ),
    );
  }
}
