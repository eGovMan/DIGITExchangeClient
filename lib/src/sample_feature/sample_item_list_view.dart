import 'package:digit_exchange_client/src/sample_feature/sample_item_details_view.dart';
import 'package:digit_exchange_client/src/services/exchange_service.dart';
import 'package:flutter/material.dart';

import '../models/request_message.dart';
import '../settings/settings_view.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiscal Messages'),
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

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
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

                return ListTile(
                  title: Text(
                      "${item.header.fiscalMessage.fiscalMessageType}:${item.header.senderId}"), // Adjust according to your model structure
                  leading: const CircleAvatar(
                    foregroundImage:
                        AssetImage('assets/images/flutter_logo.png'),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SampleItemDetailsView(requestMessage: item),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
