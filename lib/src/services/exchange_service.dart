import 'dart:convert';
import 'package:digit_exchange_client/src/models/request_message.dart';
import 'package:http/http.dart' as http;

class ExchangeService {
  Future<List<RequestMessage>> inbox() async {
    var url = Uri.parse('http://127.0.0.1:8080/exchange/v1/inbox');

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "signature": "",
          "header": {
            "receiver_id": "finance@http://127.0.0.1:8080",
            "version": "1.0.0",
            "message_id": "123",
            "message_ts": "2011-12-03T10:15:30+01:00[Europe/Paris]",
            "action": "create",
            "sender_id": "finance@127.0.0.1:8080"
          },
          "message": "{\"page\": 0,\"size\": 50}"
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> content = data['content'];
        return content.map((json) => RequestMessage.fromJson(json)).toList();
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
