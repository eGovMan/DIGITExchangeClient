import 'package:digit_exchange_client/src/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'editable_dropdown_controller.dart';

class EditableDropdown extends StatefulWidget {
  final String label;
  final Future<List<String>> Function(AuthService, String) fetchSuggestions;
  final AuthService authService;
  final EditableDropdownController controller;

  const EditableDropdown(
      {Key? key,
      required this.label,
      required this.fetchSuggestions,
      required this.authService,
      required this.controller})
      : super(key: key);

  @override
  _EditableDropdownState createState() => _EditableDropdownState();
}

class _EditableDropdownState extends State<EditableDropdown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return await widget.fetchSuggestions(
            widget.authService, textEditingValue.text);
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        textEditingController.text = widget.controller.currentValue;
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
          ),
        );
      },
      onSelected: (String selection) {
        widget.controller.currentValue = selection;
      },
    );
  }
}
