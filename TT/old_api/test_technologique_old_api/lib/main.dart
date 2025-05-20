import 'package:flutter/material.dart';
import 'api/api_service.dart'; // Assure-toi que ce fichier est bien placé dans lib/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy JSON DB Tester',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Tester Easy JSON DB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _keyController = TextEditingController();
  String _result = '';

  final ApiService apiService = ApiService();

  void _getValue() async {
    final key = _keyController.text.trim();

    if (key.isEmpty) {
      setState(() => _result = 'Veuillez entrer une clé.');
      return;
    }

    try {
      final value = await apiService.getValue(key);
      setState(() => _result = value);
    } catch (e) {
      setState(() => _result = 'Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(labelText: 'Clé (key)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getValue,
              child: const Text('Lire (GET)'),
            ),
            const SizedBox(height: 20),
            Text(
              'Résultat :',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              _result,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
