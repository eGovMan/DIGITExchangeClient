import 'dart:convert';
import 'package:digit_exchange_client/src/models/individual.dart';
import 'package:digit_exchange_client/src/models/message.dart';
import 'package:digit_exchange_client/src/models/new_message.dart';
import 'package:digit_exchange_client/src/models/organisation.dart';
import 'package:digit_exchange_client/src/services/auth_service.dart';

class ExchangeService {
  List<Organisation>? _organisationsByLoggedInUser;

  ExchangeService();

  Future<List<Message>> inbox(AuthService auth, String search) async {
    var url = Uri.parse('http://127.0.0.1:8080/exchange/v1/inbox');
    var body = {"search_string": search, "page": 0, "size": 50};

    try {
      var response = await auth.post(url, body);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var data = json.decode(response.body);
        List<dynamic> content = data['content'];
        return content.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception(("No Items in Inbox"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<Message>> sentitems(AuthService auth, String search) async {
    var url = Uri.parse('http://127.0.0.1:8080/exchange/v1/sentitems');
    var body = {"search_string": search, "page": 0, "size": 50};

    try {
      var response = await auth.post(url, body);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var data = json.decode(response.body);
        List<dynamic> content = data['content'];
        return content.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception(("No Items in Inbox"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<Individual>> individuals(
      AuthService auth, String searchString) async {
    var url =
        Uri.parse('http://127.0.0.1:8080/exchange/v1/admin/individual/search');
    var body = {"search_string": searchString, "page": 0, "size": 50};
    try {
      var response = await auth.post(url, body);
      if (response.body.isNotEmpty) {
        var data = json.decode(response.body);
        List<dynamic> content = data['content'];
        return content.map((json) => Individual.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw Exception(("Access Denied"));
      } else {
        throw Exception(("No Individuals"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Individual> individualCreate(
      AuthService auth, Individual individual) async {
    var url =
        Uri.parse('http://127.0.0.1:8080/exchange/v1/admin/individual/create');
    var body = individual.toJson();
    try {
      var response = await auth.post(url, body);
      if (response.body.isNotEmpty) {
        // var data = json.decode(response.body);
        // List<dynamic> content = data['content'];
        // return content.map((json) => Individual.fromJson(json)).toList();
        return individual;
      } else if (response.statusCode == 403) {
        throw Exception(("Access Denied"));
      } else {
        throw Exception(("No Individuals"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Individual> individualUpdate(
      AuthService auth, Individual individual) async {
    var url =
        Uri.parse('http://127.0.0.1:8080/exchange/v1/admin/individual/update');
    var body = individual.toJson();
    try {
      var response = await auth.post(url, body);
      if (response.body.isNotEmpty) {
        // var data = json.decode(response.body);
        // List<dynamic> content = data['content'];
        // return content.map((json) => Individual.fromJson(json)).toList();
        return individual;
      } else if (response.statusCode == 403) {
        throw Exception(("Access Denied"));
      } else {
        throw Exception(("No Individuals"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<Organisation>> organisations(
      AuthService auth, String searchString) async {
    var url = Uri.parse('http://127.0.0.1:8080/exchange/v1/agency/search');
    var body = {"search_string": searchString, "page": 0, "size": 50};
    try {
      var response = await auth.post(url, body);
      if (response.body.isNotEmpty) {
        var data = json.decode(response.body);
        List<dynamic> content = data['content'];
        return content.map((json) => Organisation.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw Exception(("Access Denied"));
      } else {
        throw Exception(("No Organisations"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<Organisation>> organisationsByAdminId(
      AuthService auth, String adminId) async {
    if (_organisationsByLoggedInUser != null) {
      return _organisationsByLoggedInUser ?? [];
    }

    var url =
        Uri.parse('http://127.0.0.1:8080/exchange/v1/agency/getbyadminid');
    try {
      var body = {"search_string": adminId, "page": 0, "size": 50};

      var response = await auth.post(url, body);
      if (response.body.isNotEmpty) {
        var data = json.decode(response.body);
        List<dynamic> content = data['content'];
        _organisationsByLoggedInUser =
            content.map((json) => Organisation.fromJson(json)).toList();
        return _organisationsByLoggedInUser ?? [];
      } else if (response.statusCode == 403) {
        throw Exception(("Access Denied"));
      } else {
        throw Exception(("No Organisations"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Organisation> organisationCreate(
      AuthService auth, Organisation organisation) async {
    var url =
        Uri.parse('http://127.0.0.1:8080/exchange/v1/admin/agency/create');
    var body = organisation.toJson();
    try {
      var response = await auth.post(url, body);
      if (response.body.isNotEmpty) {
        // var data = json.decode(response.body);
        // List<dynamic> content = data['content'];
        // return content.map((json) => Organisation.fromJson(json)).toList();
        return organisation;
      } else if (response.statusCode == 403) {
        throw Exception(("Access Denied"));
      } else {
        throw Exception(("No Organisations"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Organisation> organisationUpdate(
      AuthService auth, Organisation organisation) async {
    var url =
        Uri.parse('http://127.0.0.1:8080/exchange/v1/admin/agency/update');
    var body = organisation.toJson();
    try {
      var response = await auth.post(url, body);
      if (response.body.isNotEmpty) {
        // var data = json.decode(response.body);
        // List<dynamic> content = data['content'];
        // return content.map((json) => Organisation.fromJson(json)).toList();
        return organisation;
      } else if (response.statusCode == 403) {
        throw Exception(("Access Denied"));
      } else {
        throw Exception(("No Organisations"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<String>> messageTypes(AuthService auth, String id) async {
    var url =
        Uri.parse('http://127.0.0.1:8080/exchange/v1/agency/messagetypes');
    var body = id;
    try {
      var response = await auth.postString(url, body);
      if (response.body.isNotEmpty) {
        var data = json.decode(response.body);
        if (data is List) {
          // Cast each element in the list to String
          return data.map((e) => e.toString()).toList();
        } else {
          throw Exception("Data format is not a list");
        }
      } else if (response.statusCode == 403) {
        throw Exception(("Access Denied"));
      } else {
        throw Exception(("No Message Types"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to fetch data: $e');
    }
  }

  addresses(AuthService auth, String searchString) {}

  sendMessage(AuthService auth, NewMessage message) async {
    var url = Uri.parse('http://127.0.0.1:8080/exchange/v1/sendMessage');
    var body = message.toJson();
    try {
      var response = await auth.post(url, body);
      if (response.body.isNotEmpty) {
        var data = json.decode(response.body);
        return Message.fromJson(data);
      } else if (response.statusCode == 403) {
        throw Exception(("Access Denied"));
      }
    } catch (e) {
      // You can handle specific exceptions if you need to
      throw Exception('Failed to send message: $e');
    }
  }
}
