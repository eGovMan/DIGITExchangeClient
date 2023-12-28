import 'package:flutter/material.dart';

import 'login_service.dart';

class LoginController with ChangeNotifier {
  LoginController();

  final LoginService _loginService = LoginService();

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the LoginService.
  late String _token = "";

  /// Load the user's settings from the LoginService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> login(username, password) async {
    _token = await _loginService.login(username, password);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }
}
