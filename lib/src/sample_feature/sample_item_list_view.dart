import 'package:digit_exchange_client/src/models/message.dart';
import 'package:digit_exchange_client/src/sample_feature/sample_item_details_view.dart';
import 'package:digit_exchange_client/src/services/auth_service.dart';
import 'package:digit_exchange_client/src/services/exchange_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../login/login_view.dart';
import '../models/organisation.dart';
import 'base_view.dart';
import 'message_dialog.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({Key? key})
      : super(key: key); // Added named key parameter

  // Define the routeName static variable
  static const routeName = '/inbox';

  @override
  SampleItemListViewState createState() => SampleItemListViewState();
}

class SampleItemListViewState extends State<SampleItemListView> {
  final ExchangeService _exchangeService = ExchangeService();
  String? selectedOrganisation = 'finance'; //Hardcoding.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<AuthService>(context, listen: false).initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final auth = Provider.of<AuthService>(context);
            return BaseView(
                title: 'DIGIT Exchange Client',
                body: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Messages', style: TextStyle(fontSize: 20)),
                        FutureBuilder<List<String>>(
                          future: fetchOrganisationsForLoggedInUser(auth),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasData) {
                              return DropdownButton<String>(
                                value: selectedOrganisation,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOrganisation = newValue;
                                  });
                                },
                                items: snapshot.data!
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              );
                            }
                            return Container(); // Empty container for no data case
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => showMessageDialog(null),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Message>>(
                      future: _exchangeService.inbox(
                          auth, selectedOrganisation ?? 'finance'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return ListView.builder(
                            restorationId: 'sampleItemListView',
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Message item = snapshot.data![index];
                              return _buildListItem(item);
                            },
                          );
                        }
                        return const Center(child: Text("No messages"));
                      },
                    ),
                  )
                ]));
          } else {
            // While loading the token, show a loading indicator or similar
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _buildListItem(Message item) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Colors.blue, // Choose a background color for the circle
        child: Text(
          item.header.messageType.isNotEmpty
              ? item.header.messageType[0].toUpperCase()
              : '', // Get the first letter and make it uppercase
          style: const TextStyle(color: Colors.white), // Set the text color
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 150, // Minimum width for the first column
            child: Text(
              item.header.senderId,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(
              item.header.messageType,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
              width: 40, // Fixed width for the last column; adjust as needed
              child: Align(
                alignment: Alignment.centerRight, // Right aligns the text
                child: Text(
                  formatDate(item.header
                      .messageTs), // Assuming formatDate is your method to format the date
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SampleItemDetailsView(requestMessage: item),
          ),
        );
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

  void showMessageDialog(Message? message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(from: selectedOrganisation ?? '');
      },
    );
  }

  Future<List<String>> fetchOrganisationsForLoggedInUser(
      AuthService auth) async {
    String loggedInUser = await auth.getUserIdFromToken();
    return _exchangeService
        .organisationsByAdminId(auth, loggedInUser)
        .then((List<Organisation> organisations) {
      return organisations.map((organisation) => organisation.id).toList();
    });
  }
}
