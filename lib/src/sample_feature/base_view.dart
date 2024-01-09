import 'package:digit_exchange_client/src/sample_feature/individual/individual_list_view.dart';
import 'package:digit_exchange_client/src/sample_feature/sample_item_list_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import '../settings/settings_view.dart';
import 'organisation/organisation_list_view.dart';

class BaseView extends StatefulWidget {
  final String title;
  final Widget body;

  const BaseView({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  BaseViewState createState() => BaseViewState();
}

class BaseViewState extends State<BaseView> {
  String? selectedMessageType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DIGIT Exchange'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const Divider(),
            ListTile(
              title: const Text('Inbox'),
              onTap: () {
                Navigator.pushNamed(context, SampleItemListView.routeName);
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
                Navigator.pushNamed(context, SettingsView.routeName);
              },
            ),
            ListTile(
              title: const Text('Organisations'),
              onTap: () {
                Navigator.pushNamed(context, OrganisationListView.routeName);
              },
            ),
            ListTile(
              title: const Text('Individuals'),
              onTap: () {
                Navigator.pushNamed(context, IndividualListView.routeName);
              },
            ),
          ],
        ),
      ),
      body: widget.body,
    );
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
}
