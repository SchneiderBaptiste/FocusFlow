import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String email = "schneiderbaptiste1637@gmail.com";
  final String secretCode = "42EE6C7B35F8";
  final String baseUrl = "https://www.polosoft.ch/easy-json-db/api/v1/accounts/account/entry";

  Future<String> getValue(String key) async {
    final url = Uri.https(
      "$baseUrl/load/?account_email=$email&secret_code=$secretCode&key=$key",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body["jsondata"] ?? "Aucune donnée reçue.";
    } else {
      throw Exception("Erreur GET : ${response.statusCode}");
    }
  }
}
