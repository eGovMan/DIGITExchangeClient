import 'package:flutter/material.dart';

import 'login_service.dart';

class LoginController with ChangeNotifier {
  final LoginService _loginService = LoginService();

  late String _token = "";

  String get token => _token;

  Future<void> login(username, password) async {
    _token = await _loginService.login(username, password);
    notifyListeners();
  }
}
