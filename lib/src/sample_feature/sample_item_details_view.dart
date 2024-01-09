import 'package:digit_exchange_client/src/models/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../models/message.dart';
import 'base_view.dart';
import 'message_dialog.dart';

class SampleItemDetailsView extends StatelessWidget {
  final Message requestMessage;

  const SampleItemDetailsView({Key? key, required this.requestMessage})
      : super(key: key);
  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
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
            buildMessageWidget(requestMessage.message),
            ElevatedButton(
              onPressed: () {
                showMessageDialog(context, requestMessage);
              },
              child: const Text('Reply'),
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
    var now = DateTime.now().toUtc();
    var difference = now.difference(messageTs);

    var formattedDate = DateFormat("MMM dd, yyyy hh:mm a").format(messageTs);
    String timeAgo;
    if (difference.inHours == 0) {
      // Show minutes if the difference in hours is zero
      timeAgo = "${difference.inMinutes} mins ago";
    } else {
      // Show hours otherwise
      timeAgo = "${difference.inHours} hours ago";
    }
    return "$formattedDate ($timeAgo)";
  }

  bool isJson(String str) {
    try {
      json.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  void showMessageDialog(BuildContext context, Message message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MessageDialog(
            from: message.header.receiverId,
            replyToMessageId: message.header.id,
            replyTo: message.header.senderId,
            replyToMessage: message.message);
      },
    );
  }

  Widget buildMessageWidget(String message) {
    if (isJson(message)) {
      Map<String, dynamic> messageJson = json.decode(message);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: messageJson.entries
            .map((entry) => Text('Key: ${entry.key}, Value: ${entry.value}'))
            .toList(),
      );
    } else {
      return TextField(
        controller: TextEditingController(text: message),
        readOnly: true, // makes it non-editable
        maxLines: null, // makes it expand as needed
      );
    }
  }
}
