import 'package:digit_exchange_client/src/login/login_controller.dart';
import 'package:flutter/material.dart';

import '../sample_feature/sample_item_list_view.dart';

// import 'login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  static const routeName = '/login';

  final LoginController controller = LoginController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                String username = usernameController.text;
                String password = passwordController.text;
                // Call your login method with username and password
                controller.login(username, password);
                Navigator.pushReplacementNamed(
                    context, SampleItemListView.routeName);
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
