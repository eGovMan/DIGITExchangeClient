import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  late Future<void> initialization;
  late String _token = "";

  String get token => _token;
  AuthService() {
    initialization = _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('jwt_token') ?? "";
    notifyListeners();
  }

  Future<String> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<void> setStoredToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    notifyListeners();
  }

  Future<String> refreshToken() async {
    // Replace with your refresh endpoint
    final response = await http.post(Uri.parse('https://your.api/refresh'));
    if (response.statusCode == 200) {
      // Assuming the response body contains the new token
      final newToken = response.body;
      await setStoredToken(newToken);
      return newToken;
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<http.Response> get(Uri url) async {
    var token = await getStoredToken();

    // Check if the token is expired and refresh it if needed
    if (isTokenExpired(token)) {
      token = await refreshToken();
    }

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 401) {
      // Token might have expired during the request; refresh and retry
      token = await refreshToken();
      return await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
    }
    return response;
  }

  Future<http.Response> post(Uri url, Map<String, dynamic> body) async {
    var token = await getStoredToken();

    // Check if the token is expired and refresh it if needed
    if (isTokenExpired(token)) {
      token = await refreshToken();
    }

    // Make the initial POST request
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    // Check if token expired during the request, refresh it and retry
    if (response.statusCode == 401) {
      token = await refreshToken();
      response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );
    }

    return response;
  }

  bool isTokenExpired(String token) {
    if (token.isEmpty) return true;

    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        // Invalid token format
        return true;
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);

      if (!payloadMap.containsKey('exp')) {
        // Expiration claim not found
        return true;
      }

      final currentTime = DateTime.now().toUtc().millisecondsSinceEpoch / 1000;
      final exp = payloadMap['exp'];

      return currentTime > exp;
    } catch (e) {
      // In case of error, assume the token is expired
      return true;
    }
  }
}
