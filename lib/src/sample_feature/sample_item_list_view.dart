import 'package:digit_exchange_client/src/sample_feature/sample_item_details_view.dart';
import 'package:digit_exchange_client/src/services/exchange_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/request_message.dart';
import '../settings/settings_view.dart';
import 'base_view.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({Key? key})
      : super(key: key); // Added named key parameter

  // Define the routeName static variable
  static const String routeName = '/sampleItemListView';

  @override
  SampleItemListViewState createState() => SampleItemListViewState();
}

class SampleItemListViewState extends State<SampleItemListView> {
  final ExchangeService _exchangeService = ExchangeService();
  String _selectedComposeOption = 'Compose';

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Inbox',
      body: FutureBuilder<List<RequestMessage>>(
        future: _exchangeService.inbox(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              restorationId: 'sampleItemListView',
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final RequestMessage item = snapshot.data![index];
                return _buildListItem(item);
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
    // Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Inbox'),
    //     actions: [
    //       IconButton(
    //         icon: const Icon(Icons.settings),
    //         onPressed: () {
    //           // Navigate to the settings page. If the user leaves and returns
    //           // to the app after it has been killed while running in the
    //           // background, the navigation stack is restored.
    //           Navigator.restorablePushNamed(context, SettingsView.routeName);
    //         },
    //       ),
    //     ],
    //   ),
    //   drawer: Drawer(
    //     child: ListView(
    //       padding: EdgeInsets.zero,
    //       children: <Widget>[
    //         ListTile(
    //           title: DropdownButton<String>(
    //             value: _selectedComposeOption,
    //             onChanged: (String? newValue) {
    //               if (newValue != null) {
    //                 setState(() {
    //                   _selectedComposeOption = newValue;
    //                 });
    //                 _showComposeDialog(newValue);
    //               }
    //             },
    //             items: <String>[
    //               'Compose',
    //               'Program',
    //               'Estimate',
    //               'Sanction',
    //               'Allocation',
    //               'Disburse'
    //             ].map<DropdownMenuItem<String>>((String value) {
    //               return DropdownMenuItem<String>(
    //                 value: value,
    //                 child: Text(value),
    //               );
    //             }).toList(),
    //           ),
    //         ),
    //         Divider(),
    //         ListTile(
    //           title: const Text('Inbox'),
    //           onTap: () {
    //             Navigator.pushNamed(context,
    //                 SampleItemListView.routeName); // Navigate to Inbox View
    //           },
    //         ),
    //         ListTile(
    //           title: const Text('Sent Items'),
    //           onTap: () {
    //             // Navigate to Sent Items View
    //           },
    //         ),
    //         Divider(),
    //         ListTile(
    //           title: const Text('Settings'),
    //           onTap: () {
    //             Navigator.pushNamed(context,
    //                 SettingsView.routeName); // Navigate to Settings View
    //           },
    //         ),
    //         ListTile(
    //           title: const Text('Account'),
    //           onTap: () {
    //             // Navigate to Account View
    //           },
    //         ),
    //       ],
    //     ),
    //   ),

    // To work with lists that may contain a large number of items, it’s best
    // to use the ListView.builder constructor.
    //
    // In contrast to the default ListView constructor, which requires
    // building all Widgets up front, the ListView.builder constructor lazily
    // builds Widgets as they’re scrolled into view.
    // body: FutureBuilder<List<RequestMessage>>(
    //   future: _exchangeService.inbox(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else if (snapshot.hasError) {
    //       return Center(child: Text('Error: ${snapshot.error}'));
    //     } else if (snapshot.hasData) {
    //       return ListView.builder(
    //         restorationId: 'sampleItemListView',
    //         itemCount: snapshot.data!.length,
    //         itemBuilder: (BuildContext context, int index) {
    //           final RequestMessage item = snapshot.data![index];

    //           return ListTile(
    //             leading: CircleAvatar(
    //               backgroundColor:
    //                   Colors.blue, // Choose a background color for the circle
    //               child: Text(
    //                 item.header.messageType.isNotEmpty
    //                     ? item.header.messageType[0].toUpperCase()
    //                     : '', // Get the first letter and make it uppercase
    //                 style: const TextStyle(
    //                     color: Colors.white), // Set the text color
    //               ),
    //             ),
    //             title: Row(
    //               children: [
    //                 Container(
    //                   width: 150, // Minimum width for the first column
    //                   child: Text(
    //                     item.header.senderId,
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                 ),
    //                 Expanded(
    //                   flex: 8,
    //                   child: Text(
    //                     item.header.messageType,
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                 ),
    //                 Container(
    //                     width:
    //                         40, // Fixed width for the last column; adjust as needed
    //                     child: Align(
    //                       alignment:
    //                           Alignment.centerRight, // Right aligns the text
    //                       child: Text(
    //                         formatDate(item.header
    //                             .messageTs), // Assuming formatDate is your method to format the date
    //                         style:
    //                             TextStyle(fontSize: 12, color: Colors.grey),
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     )),
    //               ],
    //             ),
    //             onTap: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) =>
    //                       SampleItemDetailsView(requestMessage: item),
    //                 ),
    //               );
    //             },
    //           );
    //         },
    //       );
    //     } else {
    //       return const Center(child: Text('No data available'));
    //     }
    //   },
    // ),
  }

  Widget _buildListItem(RequestMessage item) {
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
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
}
