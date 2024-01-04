import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  Future<String> login(username, password) async {
    var url =
        Uri.parse('http://127.0.0.1:8080/exchange/v1/public/authenticate');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"user_id": username, "pin": password}),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var data = response.body;
          String token = data;
          return token;
        } else {
          throw Exception("Server did not return a valid token.");
        }
      } else {
        // Handle different status codes here if needed
        throw Exception(
            'Failed to load data with status code: ${response.statusCode}');
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }
}
