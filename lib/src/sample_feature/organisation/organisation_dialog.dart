import 'package:digit_exchange_client/src/components/address_control.dart';
import 'package:digit_exchange_client/src/components/editable_dropdown_controller.dart';
import 'package:digit_exchange_client/src/models/address.dart';
import 'package:digit_exchange_client/src/models/individual.dart';
import 'package:digit_exchange_client/src/models/organisation.dart';
import 'package:digit_exchange_client/src/sample_feature/organisation/organisation_list_view.dart';
import 'package:digit_exchange_client/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/editable_dropdown.dart';
import '../../services/exchange_service.dart';

class OrganisationDialog extends StatefulWidget {
  final Organisation? organisation;

  const OrganisationDialog({super.key, this.organisation});

  @override
  _OrganisationDialogState createState() => _OrganisationDialogState();
}

class _OrganisationDialogState extends State<OrganisationDialog> {
  final ExchangeService _exchangeService = ExchangeService();

  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController urlController;
  Address address = Address();
  late EditableDropdownController administratorIdController;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.organisation?.id ?? '');
    nameController =
        TextEditingController(text: widget.organisation?.name ?? '');
    administratorIdController = EditableDropdownController();
    administratorIdController.currentValue =
        widget.organisation?.administratorId ?? '';
    urlController = TextEditingController(
        text: widget.organisation?.digitExchangeUrl ?? '');
    address = Address();
    isChecked = widget.organisation?.isActive ?? false;
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
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
              title: Text(widget.organisation != null
                  ? 'Edit Organisation'
                  : 'Add Organisation'),
              content: SingleChildScrollView(
                  child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: idController,
                    decoration: const InputDecoration(labelText: 'ID'),
                    // Use 'organisation.name' to prefill if 'organisation' is not null
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    // Use 'organisation.name' to prefill if 'organisation' is not null
                  ),
                  TextField(
                    controller: urlController,
                    decoration: const InputDecoration(labelText: 'Url'),
                    // Use 'organisation.name' to prefill if 'organisation' is not null
                  ),
                  // AddressControl(initialAddress: address),
                  EditableDropdown(
                      label: "Administrator",
                      fetchSuggestions: fetchIndividuals,
                      authService: auth,
                      controller: administratorIdController),
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
                    Organisation organisationNew = Organisation(
                        id: idController.text,
                        name: nameController.text,
                        // address: address,
                        digitExchangeUrl: urlController.text,
                        orgRoles: [OrganisationRole.IMPLEMENTING_AGENCY],
                        administratorId: administratorIdController.currentValue,
                        isActive: isChecked);
                    try {
                      if (widget.organisation != null) {
                        _exchangeService.organisationUpdate(
                            auth, organisationNew);
                      } else {
                        _exchangeService.organisationCreate(
                            auth, organisationNew);
                      }
                      // Navigator.of(context).pop();
                      // Token is not available, redirect to login screen
                      Future.microtask(() => Navigator.of(context)
                          .pushReplacementNamed(
                              OrganisationListView.routeName));
                    } catch (error) {
                      // Handle the error and show a message to the user
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Failed to save to server: ${error.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
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

  Future<List<String>> fetchIndividuals(
      AuthService auth, String searchString) async {
    return _exchangeService
        .individuals(auth, searchString)
        .then((List<Individual> individuals) {
      return individuals.map((individual) => individual.id).toList();
    });
  }
}
