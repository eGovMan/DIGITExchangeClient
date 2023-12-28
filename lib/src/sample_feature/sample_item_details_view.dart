import 'package:flutter/material.dart';

import '../models/request_message.dart';

// /// Displays detailed information about a SampleItem.
// class SampleItemDetailsView extends StatelessWidget {
//   const SampleItemDetailsView({super.key});

//   static const routeName = '/sample_item';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Item Details'),
//       ),
//       body: const Center(
//         child: Text('More Information Here'),
//       ),
//     );
//   }
// }

class SampleItemDetailsView extends StatelessWidget {
  final RequestMessage requestMessage;

  const SampleItemDetailsView({Key? key, required this.requestMessage})
      : super(key: key);
  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Details for ${"${requestMessage.header.fiscalMessage.fiscalMessageType} from ${requestMessage.header.senderId}"}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('ID: ${requestMessage.id}'),
            Text('Header Version: ${requestMessage.header.version}'),
            Text('Header MessageId: ${requestMessage.header.messageId}'),
            Text('Header TimeStamp: ${requestMessage.header.messageTs}'),
            Text('Header SenderId: ${requestMessage.header.senderId}'),
            Text('Header Action: ${requestMessage.header.action}'),
            Text(
                'Fiscal Message Type: ${requestMessage.header.fiscalMessage.fiscalMessageType}'),
            Text(
                'Fiscal Function Type: ${requestMessage.header.fiscalMessage.functionCode}'),
            Text(
                'Fiscal Administration Type: ${requestMessage.header.fiscalMessage.administrationCode}'),
            Text(
                'Fiscal Segment Type: ${requestMessage.header.fiscalMessage.economicSegmentCode}'),
            Text(
                'Fiscal Location: ${requestMessage.header.fiscalMessage.locationCode}'),
            Text(
                'Fiscal Gross Amount: ${requestMessage.header.fiscalMessage.grossAmount}'),
            Text(
                'Fiscal Net Amount: ${requestMessage.header.fiscalMessage.netAmount}'),
            Text(
                'Fiscal Start Date: ${requestMessage.header.fiscalMessage.startDate}'),
            Text(
                'Fiscal End Date: ${requestMessage.header.fiscalMessage.endDate}'),
          ],
        ),
      ),
    );
  }
}
