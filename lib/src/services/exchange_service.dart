import 'dart:convert';
import 'package:digit_exchange_client/src/models/request_message.dart';
import 'package:http/http.dart' as http;

class ExchangeService {
  ExchangeService();

  Future<List<RequestMessage>> inbox(String token) async {
    var url = Uri.parse('http://127.0.0.1:8080/exchange/v1/inbox');

    try {
      var response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "receiver_id": "line@http://127.0.0.1:8080",
          "page": 0,
          "size": 50
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var data = json.decode(response.body);
          List<dynamic> content = data['content'];
          return content.map((json) => RequestMessage.fromJson(json)).toList();
        } else {
          throw Exception(("No Items in Inbox"));
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
