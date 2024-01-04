import 'package:digit_exchange_client/src/login/login_view.dart';
import 'package:digit_exchange_client/src/sample_feature/sample_item_list_view.dart';
import 'package:digit_exchange_client/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Log, send to a server, or display an error message

    // Call the default error handler to show the error in the console
    FlutterError.dumpErrorToConsole(details);
  };

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}

class MyAppWithProvider extends StatelessWidget {
  final SettingsController settingsController;

  const MyAppWithProvider({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(), // Provide your AuthService
      child: MyApp(settingsController: settingsController),
    );
  }
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController;

  const MyApp({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'DIGIT Exchange Client',
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginView(),
          SampleItemListView.routeName: (context) => const SampleItemListView(),
          // Add other routes here
        },
      ),
    );
  }
}
