enum Action {
  create,
}

// Optional: Extension on the Dart enum for additional functionality
extension ActionExtension on Action {
  String get name => toString().split('.').last;
}

Action? parseAction(String value) {
  for (Action action in Action.values) {
    if (action.toString().split('.').last == value.toLowerCase()) {
      return action;
    }
  }
  return null; // or throw an exception, depending on your error handling strategy
}
