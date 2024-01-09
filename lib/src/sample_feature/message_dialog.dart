import 'package:digit_exchange_client/src/components/editable_dropdown_controller.dart';
import 'package:digit_exchange_client/src/models/new_message.dart';
import 'package:digit_exchange_client/src/models/organisation.dart';
import 'package:digit_exchange_client/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../components/editable_dropdown.dart';
import '../models/message.dart';
import '../services/exchange_service.dart';

class MessageDialog extends StatefulWidget {
  final String? replyToMessageId;
  final String? replyTo;
  final String? replyToMessage;
  final String from;

  const MessageDialog(
      {super.key,
      required this.from,
      this.replyToMessageId,
      this.replyTo,
      this.replyToMessage});

  @override
  _MessageDialogState createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  final ExchangeService _exchangeService = ExchangeService();

  String? selectedMessageType;
  final TextEditingController messageBodyController = TextEditingController();
  final EditableDropdownController individualController =
      EditableDropdownController();

  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    individualController.currentValue = widget.replyTo ?? '';
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
              title: Text(
                  widget.replyTo != null ? 'Reply Message' : 'New Message'),
              content: SingleChildScrollView(
                  child: ListBody(
                children: <Widget>[
                  EditableDropdown(
                    label: "To",
                    fetchSuggestions: fetchSuggestions,
                    authService: auth,
                    controller: individualController,
                  ),
                  FutureBuilder<List<String>>(
                    future: fetchMessageTypes(auth, "line"),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return DropdownButtonFormField<String>(
                          value: selectedMessageType,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMessageType = newValue;
                            });
                          },
                          items: snapshot.data!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('No message types available');
                      }
                    },
                  ),
                  TextFormField(
                    controller: messageBodyController,
                    decoration:
                        const InputDecoration(labelText: 'Message Body'),
                    maxLines: 5,
                  ),
                  if (selectedMessageType != null)
                    getMessageTypeForm(selectedMessageType!),
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
                    NewMessage newMessage = NewMessage(
                        widget.from!,
                        individualController.currentValue,
                        messageBodyController.text);
                    sendMessage(auth, newMessage);
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
      case 'Program':
        return const Text('Form for Type 1');
      case 'Estimate':
        return const Text('Form for Type 2');
      default:
        return Container(); // Returns an empty container for unknown types
    }
  }

  Future<List<String>> fetchSuggestions(
      AuthService auth, String searchString) async {
    return _exchangeService
        .organisations(auth, searchString)
        .then((List<Organisation> organisations) {
      return organisations.map((organisation) => organisation.id).toList();
    });
  }

  Future<List<String>> fetchMessageTypes(AuthService auth, String id) async {
    return _exchangeService
        .messageTypes(auth, id)
        .then((List<String> messageTypes) {
      var log = Logger('Digit Exchange Logger');
      log.info(messageTypes);
      return messageTypes;
    });
  }

  Future<Message> sendMessage(AuthService auth, NewMessage message) async {
    return _exchangeService
        .sendMessage(auth, message)
        .then((List<String> message) {
      var log = Logger('Digit Exchange Logger');
      log.info(message);
      return message;
    });
  }

  // Future<List<String>> fetchMessageSchema(AuthService auth, String id) async {
  //   return _exchangeService
  //       .messageSchema(auth, id)
  //       .then((List<String> messageTypes) {
  //     var log = Logger('Digit Exchange Logger');
  //     log.info(messageTypes);
  //     return messageTypes;
  //   });
  // }
}
