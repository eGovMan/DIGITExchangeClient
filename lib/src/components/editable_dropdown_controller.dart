import 'package:flutter/material.dart';

class EditableDropdownController {
  TextEditingController _controller = TextEditingController();

  // Getter to retrieve the current value
  String get currentValue => _controller.text;

  // Setter to set the value
  set currentValue(String? newValue) {
    _controller.text = newValue!;
  }
}
