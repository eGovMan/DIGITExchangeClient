import 'package:digit_exchange_client/src/models/organisation.dart';
import 'package:digit_exchange_client/src/sample_feature/organisation/organisation_dialog.dart';
import 'package:digit_exchange_client/src/services/auth_service.dart';
import 'package:digit_exchange_client/src/services/exchange_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import '../base_view.dart';

class OrganisationListView extends StatefulWidget {
  const OrganisationListView({Key? key})
      : super(key: key); // Added named key parameter

  // Define the routeName static variable
  static const routeName = '/organisation';

  @override
  OrganisationListViewState createState() => OrganisationListViewState();
}

class OrganisationListViewState extends State<OrganisationListView> {
  final ExchangeService _exchangeService = ExchangeService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<AuthService>(context, listen: false).initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final controller = Provider.of<AuthService>(context);
            return BaseView(
                title: 'Organisations',
                body: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Organisation',
                            style: TextStyle(fontSize: 20)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _showOrganisationDialog(
                              null), // null for new organisation
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: FutureBuilder<List<Organisation>>(
                          future:
                              _exchangeService.organisations(controller, ""),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              var log = Logger('Digit Exchange Logger');
                              log.info(snapshot.data);
                              // Token is available, proceed with your logic
                              return ListView.builder(
                                  restorationId: 'OrganisationListView',
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Organisation item =
                                        snapshot.data![index];
                                    return _buildListItem(item);
                                  });
                            } else {
                              return const Center(
                                  child: Text('No data available'));
                            }
                          }))
                ]));
          } else {
            // While loading the token, show a loading indicator or similar
            return const CircularProgressIndicator();
          }
        });
  }

  void _showOrganisationDialog(Organisation? organisation) {
    // Show a dialog for adding or updating an organisation
    // Populate the dialog with 'organisation' details if it's not null (for update)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrganisationDialog(organisation: organisation);
      },
    );
  }

  Widget _buildListItem(Organisation item) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Colors.blue, // Choose a background color for the circle
        child: Text(
          item.id.isNotEmpty
              ? item.id[0].toUpperCase()
              : '', // Get the first letter and make it uppercase
          style: const TextStyle(color: Colors.white), // Set the text color
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 150,
            child: Text(
              item.id,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              item.name,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
      onTap: () {
        _showOrganisationDialog(item);
      },
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
