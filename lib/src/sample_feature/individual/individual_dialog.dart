import 'package:digit_exchange_client/src/models/individual.dart';
import 'package:digit_exchange_client/src/models/organisation.dart';
import 'package:digit_exchange_client/src/sample_feature/individual/individual_list_view.dart';
import 'package:digit_exchange_client/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/exchange_service.dart';

class IndividualDialog extends StatefulWidget {
  final Individual? individual;

  const IndividualDialog({super.key, this.individual});

  @override
  _IndividualDialogState createState() => _IndividualDialogState();
}

class _IndividualDialogState extends State<IndividualDialog> {
  final ExchangeService _exchangeService = ExchangeService();

  late TextEditingController idController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.individual?.id ?? '');
    emailController =
        TextEditingController(text: widget.individual?.email ?? '');
    phoneController =
        TextEditingController(text: widget.individual?.phone ?? '');
    isChecked = widget.individual?.isActive ?? false;
  }

  @override
  void dispose() {
    idController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<AuthService>(context, listen: false).initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Now you can safely access the LoginController
            final auth = Provider.of<AuthService>(context);
            return AlertDialog(
              title: Text(widget.individual != null
                  ? 'Edit Individual'
                  : 'Add Individual'),
              content: SingleChildScrollView(
                  child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: idController,
                    decoration: const InputDecoration(labelText: 'ID'),
                    // Use 'individual.name' to prefill if 'individual' is not null
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    // Use 'individual.name' to prefill if 'individual' is not null
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    // Use 'individual.name' to prefill if 'individual' is not null
                  ),
                  CheckboxListTile(
                    title: const Text("Is Active"),
                    value: isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, // Places the checkbox at the start of the ListTile
                  )
                  // Add other fields as needed
                ],
              )),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Individual individualNew = Individual(
                        id: idController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        isActive: isChecked);
                    if (widget.individual != null) {
                      _exchangeService.individualUpdate(auth, individualNew);
                    } else {
                      _exchangeService.individualCreate(auth, individualNew);
                    }
                    // Navigator.of(context).pop();
                    // Token is not available, redirect to login screen
                    Future.microtask(() => Navigator.of(context)
                        .pushReplacementNamed(IndividualListView.routeName));
                  },
                ),
              ],
            );
          } else {
            // While loading the token, show a loading indicator or similar
            return const CircularProgressIndicator();
          }
        });
  }

  Widget getMessageTypeForm(String messageType) {
    switch (messageType) {
      case 'Type 1':
        return const Text('Form for Type 1');
      case 'Type 2':
        return const Text('Form for Type 2');
      default:
        return Container(); // Returns an empty container for unknown types
    }
  }

  // Future<List<String>> fetchSuggestions(
  //     AuthService auth, String searchString) async {
  //   // // Your logic to fetch suggestions based on the query
  //   // // Example:
  //   // return ['Suggestion 1', 'Suggestion 2', 'Suggestion 3']
  //   //     .where((item) => item.contains(query))
  //   //     .toList();
  //   return _exchangeService
  //       .organisations(auth, searchString)
  //       .then((List<Organisation> organisations) {
  //     return organisations.map((organisation) => organisation.name).toList();
  //   });
  // }
}
