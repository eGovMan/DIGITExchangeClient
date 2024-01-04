import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../models/request_message.dart';
import 'base_view.dart';

class SampleItemDetailsView extends StatelessWidget {
  final RequestMessage requestMessage;

  const SampleItemDetailsView({Key? key, required this.requestMessage})
      : super(key: key);
  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    // Parse JSON string to Map
    Map<String, dynamic> messageJson = json.decode(requestMessage.message);

    // Construct the body content
    Widget bodyContent = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header Row
            Container(
              width: double.infinity,
              child: Text(
                requestMessage.header.messageType,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // Sender and Timestamp Row
            Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        requestMessage.header.senderId,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        requestMessage.header.receiverId,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatMessageTs(requestMessage.header.messageTs),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            // Message Body Row
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Assuming requestMessage.message is a Map<String, dynamic>
                ...messageJson.entries
                    .map((entry) =>
                        Text('Key: ${entry.key}, Value: ${entry.value}'))
                    .toList(),
              ],
            ),
            // Dropdown Button
            DropdownButton<String>(
              items: const [
                DropdownMenuItem(
                    value: 'processing', child: Text('Processing')),
                DropdownMenuItem(
                    value: 'approve', child: Text('Approve (Done)')),
                DropdownMenuItem(value: 'reject', child: Text('Reject (Done)')),
              ],
              onChanged: (value) {
                // Handle change
              },
              hint: const Text('Reply'),
            ),
          ],
        ));

    return BaseView(
      title:
          'Details for ${requestMessage.header.messageType} from ${requestMessage.header.senderId}',
      body: bodyContent,
    );
  }

  String formatMessageTs(DateTime messageTs) {
    var now = DateTime.now();
    var difference = now.difference(messageTs);
    var formattedDate = DateFormat("MMM dd, yyyy hh:mm a").format(messageTs);
    return "$formattedDate (${difference.inHours} hours ago)";
  }
}
