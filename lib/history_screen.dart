import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  List<String> results = [];

  @override
  void initState() {
    super.initState();
    loadCalculations();
  }

  Future<void> loadCalculations() async {
    final preferencess = await SharedPreferences.getInstance();
    setState(() {
      results = preferencess.getStringList('results') ?? [];
    });
  }

  Future<void> clearHistory() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('results');
    setState(() {
      results = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История расчетов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: clearHistory,
            tooltip: 'Очистить историю',
          ),
        ],
      ),
      body: results.isEmpty? 
      const Center(
              child: Text(
                'Нет сохраненных расчетов',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final parts = results[index].split(';');
                final mass = double.parse(parts[0]);
                final radius = double.parse(parts[1]);
                final acceleration = double.parse(parts[2]);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      'Ускорение: ${acceleration.toStringAsFixed(10)} м/с²',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Масса: $mass кг, Радиус: $radius м'),
                    trailing: Text(
                      '#${index + 1}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}