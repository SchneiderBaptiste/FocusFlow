import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://api.jsonbin.io/v3/b';
  final String _apiKey = r'$2a$10$DTESgrthUXNyuLsE8Z..WOB.n23KdOZW1kNj60g52VUxZtwkzRncW';

  /// Crée un nouveau bin avec les données fournies.
  /// [data] : Les données à stocker sous forme de Map.
  /// [binName] : Nom optionnel du bin.
  /// [isPrivate] : Détermine si le bin est privé (par défaut true).
  Future<String> createBin(Map<String, dynamic> data, {String? binName, bool isPrivate = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Master-Key': _apiKey,
      if (binName != null) 'X-Bin-Name': binName,
      'X-Bin-Private': isPrivate.toString(),
    };

    final body = jsonEncode(data);

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final binId = responseData['metadata']['id'];
        return binId;
      } else {
        // Gérer les erreurs en fonction du code de statut
        return 'Erreur : ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      // Gérer les exceptions (par exemple, problèmes de réseau)
      return 'Exception : $e';
    }
  }

  Future<String> readBin(String binId) async {
    final headers = {
      'X-Master-Key': _apiKey,
    };

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
  
  Future<String> updateBin(String binId, Map<String, dynamic> updatedData) async {
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
  Future<String> deleteBin(String binId) async {
    final headers = {
      'X-Master-Key': _apiKey,
    };

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$binId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return 'Bin supprimé avec succès';
      } else {
        return 'Erreur : ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Exception : $e';
    }
  }
}
