import 'package:flutter/material.dart';
import 'input_output.dart';
import 'history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор ускорения свободного падения',
      initialRoute: '/',
      routes: {
        '/': (context) => const InputScreen(),
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}