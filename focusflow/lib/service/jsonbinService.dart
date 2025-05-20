import 'dart:convert';
import 'package:http/http.dart' as http;

class JsonbinService {
  final String _baseUrl = 'https://api.jsonbin.io/v3/b';
  final String _apiKey =
      r'$2a$10$DTESgrthUXNyuLsE8Z..WOB.n23KdOZW1kNj60g52VUxZtwkzRncW';
  final String binId = '682b125e8960c979a59cc950';

  Future<Map<String, dynamic>> fetchData() async {
    final url = Uri.parse('https://api.jsonbin.io/v3/b/$binId/latest');
    final response = await http.get(url, headers: {'X-Master-Key': _apiKey});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['record'];
    } else {
      throw Exception('Erreur lors du chargement des données');
    }
  }

  Future<String> readBin(String binId) async {
    final headers = {'X-Master-Key': _apiKey};

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$binId/latest'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'Erreur : ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Exception : $e';
    }
  }

  Future<String> updateBin(
    String binId,
    Map<String, dynamic> updatedData,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Master-Key': _apiKey,
    };

    final body = jsonEncode(updatedData);

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$binId'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return 'Mise à jour réussie';
      } else {
        return 'Erreur : ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Exception : $e';
    }
  }

  Future<Map<String, dynamic>?> getUserData(String binId) async {
    final rawJson = await readBin(binId);
    try {
      final decoded = jsonDecode(rawJson);
      return decoded['record'];
    } catch (e) {
      print('Erreur lors de la lecture des données utilisateur : $e');
      return null;
    }
  }

  Future<void> saveTasksAndStats({
    required List<Map<String, dynamic>> tasks,
    required Map<String, dynamic> stats,
    required String userName,
  }) async {
    final url = Uri.parse('$_baseUrl/$binId');
    final body = jsonEncode({
      "userName": userName,
      "tasks": tasks,
      "stats": stats,
    });

    final headers = {
      'Content-Type': 'application/json',
      'X-Master-Key': _apiKey,
    };

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la sauvegarde des données.');
    }
  }

  Future<void> incrementPomodoroCount(String binId, String masterKey) async {
    final response = await http.get(
      Uri.parse('https://api.jsonbin.io/v3/b/$binId/latest'),
      headers: {'X-Master-Key': masterKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final stats = data['record']['stats'] ?? {};
      final newCount = (stats['pomodorosCompleted'] ?? 0) + 1;

      final updatedData = {
        ...data['record'],
        'stats': {...stats, 'pomodorosCompleted': newCount},
      };

      await http.put(
        Uri.parse('https://api.jsonbin.io/v3/b/$binId'),
        headers: {
          'Content-Type': 'application/json',
          'X-Master-Key': masterKey,
        },
        body: json.encode(updatedData),
      );
    } else {
      throw Exception(
        'Erreur lors de la lecture du bin: ${response.statusCode}',
      );
    }
  }

  Future<void> deleteTask({
    required String binId,
    required String userName,
    required Map<String, dynamic> stats,
    required String taskTitle,
  }) async {
    final existingData = await fetchData(); // récupère tout

    List tasks = existingData['tasks'] ?? [];
    tasks.removeWhere((task) => task['title'] == taskTitle);

    final updatedData = {'userName': userName, 'tasks': tasks, 'stats': stats};

    await updateBin(binId, updatedData); // _updateBin est ta méthode PUT
  }
}
