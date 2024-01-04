import 'package:digit_exchange_client/src/sample_feature/sample_item_list_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../settings/settings_view.dart';

class BaseView extends StatefulWidget {
  final String title;
  final Widget body;

  const BaseView({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  BaseViewState createState() => BaseViewState();
}

class BaseViewState extends State<BaseView> {
  String _selectedComposeOption = "Compose";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Inbox'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to the settings page. If the user leaves and returns
                // to the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: DropdownButton<String>(
                  value: _selectedComposeOption,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedComposeOption = newValue;
                      });
                      _showComposeDialog(newValue);
                    }
                  },
                  items: <String>[
                    'Compose',
                    'Program',
                    'Estimate',
                    'Sanction',
                    'Allocation',
                    'Disburse'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('Inbox'),
                onTap: () {
                  Navigator.pushNamed(context,
                      SampleItemListView.routeName); // Navigate to Inbox View
                },
              ),
              ListTile(
                title: const Text('Sent Items'),
                onTap: () {
                  // Navigate to Sent Items View
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pushNamed(context,
                      SettingsView.routeName); // Navigate to Settings View
                },
              ),
              ListTile(
                title: const Text('Account'),
                onTap: () {
                  // Navigate to Account View
                },
              ),
            ],
          ),
        ),

        // To work with lists that may contain a large number of items, it’s best
        // to use the ListView.builder constructor.
        //
        // In contrast to the default ListView constructor, which requires
        // building all Widgets up front, the ListView.builder constructor lazily
        // builds Widgets as they’re scrolled into view.
        body: widget.body);
  }

  // Create a method to format the date
  String formatDate(DateTime date) {
    if (date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day) {
      return DateFormat.Hm().format(date); // Show time for today's messages
    } else {
      return DateFormat('MMM dd')
          .format(date); // Show 'Month day' for other messages
    }
  }

  void _showComposeDialog(String composeType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Compose $composeType'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Sample form for $composeType'),
                // Add your form fields here
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
