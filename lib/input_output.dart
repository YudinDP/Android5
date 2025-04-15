import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'qubit.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  InputScreenState createState() => InputScreenState();
}

class InputScreenState extends State<InputScreen> {
  final formKey = GlobalKey<FormState>();
  final massController = TextEditingController();
  final radiusController = TextEditingController();
  bool agreeToProcessData = false;
  final CalculationQubit qubit = CalculationQubit();

  @override
  void dispose() {
    massController.dispose();
    radiusController.dispose();
    super.dispose();
  }

  Future<void> saveCalculation(double mass, double radius, double acceleration) async {
    final preferences = await SharedPreferences.getInstance();
    final results = preferences.getStringList('results') ?? [];
    
    results.add('$mass;$radius;$acceleration');
    await preferences.setStringList('results', results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Юдин Данила ВМК-22 Вариант 8'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: massController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Масса (кг)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите массу';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Пожалуйста, введите корректное число';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Масса должна быть больше нуля';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: radiusController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Радиус (метры)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите радиус';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Пожалуйста введите корректное число';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Радиус должен быть больше 0';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: agreeToProcessData,
                    onChanged: (value) {
                      setState(() {
                        agreeToProcessData = value ?? false;
                      });
                    },
                  ),
                  const Text('Соглашаюсь на обработку данных'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() && agreeToProcessData) {
                    final double mass = double.parse(massController.text);
                    final double radius = double.parse(radiusController.text);
                    final double acceleration = qubit.calculateAcceleration(mass, radius);

                    await saveCalculation(mass, radius, acceleration);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Ускорение свободного падения'),
                          content: Text(
                            'Ускорение свободного падения: ${acceleration.toStringAsFixed(10)} м/с²',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Закрыть'),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (!agreeToProcessData) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пожалуйста, подтвердите согласие на обработку данных')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Вычислить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}