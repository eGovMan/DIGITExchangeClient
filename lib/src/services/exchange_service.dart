import 'dart:convert';
import 'package:digit_exchange_client/src/models/request_message.dart';
import 'package:digit_exchange_client/src/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ExchangeService {
  ExchangeService();

  Future<List<RequestMessage>> inbox(AuthService auth) async {
    var url = Uri.parse('http://127.0.0.1:8080/exchange/v1/inbox');
    var body = {
      "receiver_id": "line@http://127.0.0.1:8080",
      "page": 0,
      "size": 50
    };

    try {
      var response = await auth.post(url, body);
      if (response.body.isNotEmpty) {
        var data = json.decode(response.body);
        List<dynamic> content = data['content'];
        return content.map((json) => RequestMessage.fromJson(json)).toList();
      } else {
        throw Exception(("No Items in Inbox"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }
}
