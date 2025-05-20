import 'package:flutter/material.dart';
import 'api/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSONBin.io Tester',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Tester JSONBin.io'),
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _binIdController = TextEditingController();
  String _result = '';

  final ApiService apiService = ApiService();

  void _createBin() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final age = int.tryParse(_ageController.text.trim());

    if (name.isEmpty || email.isEmpty || age == null) {
      setState(() {
        _result = 'Veuillez remplir correctement tous les champs.';
      });
      return;
    }

    final data = {'nom': name, 'email': email, 'age': age};
    final response = await apiService.createBin(data, binName: 'Utilisateur $name');

    setState(() {
      _result = 'Bin créé avec ID : $response';
    });
  }

  void _readBin() async {
    final binId = _binIdController.text.trim();
    if (binId.isEmpty) {
      setState(() => _result = 'Veuillez entrer un ID de bin.');
      return;
    }
    final response = await apiService.readBin(binId);
    setState(() => _result = response);
  }

  void _updateBin() async {
    final binId = _binIdController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final age = int.tryParse(_ageController.text.trim());

    if (binId.isEmpty || name.isEmpty || email.isEmpty || age == null) {
      setState(() => _result = 'Veuillez remplir tous les champs.');
      return;
    }

    final data = {'nom': name, 'email': email, 'age': age};
    final response = await apiService.updateBin(binId, data);
    setState(() => _result = response);
  }

  void _deleteBin() async {
    final binId = _binIdController.text.trim();
    if (binId.isEmpty) {
      setState(() => _result = 'Veuillez entrer un ID de bin.');
      return;
    }
    final response = await apiService.deleteBin(binId);
    setState(() => _result = response);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _binIdController,
                decoration: const InputDecoration(labelText: 'ID du Bin (pour lire/modifier/supprimer)'),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Âge'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: _createBin,
                    child: const Text('Créer'),
                  ),
                  ElevatedButton(
                    onPressed: _readBin,
                    child: const Text('Lire'),
                  ),
                  ElevatedButton(
                    onPressed: _updateBin,
                    child: const Text('Modifier'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteBin,
                    child: const Text('Supprimer'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Résultat :',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                _result,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
