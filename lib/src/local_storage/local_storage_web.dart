// import 'dart:convert';
// import 'dart:html' as html;
// import 'local_storage_service.dart";

// class LocalStorageWeb implements LocalStorageService {
//   @override
//   Future<void> saveData(String key, dynamic value) async {
//     html.window.localStorage[key] = json.encode(value);
//   }

//   @override
//   Future<dynamic> loadData(String key) async {
//     final data = html.window.localStorage[key];
//     return data != null ? json.decode(data) : null;
//   }
// }
