// import 'dart:convert';
// import 'dart:io';
// import 'local_storage_service.dart';

// class LocalStorageMobile implements LocalStorageService {
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   Future<File> _localFile(String key) async {
//     final path = await _localPath;
//     return File('$path/$key.json');
//   }

//   @override
//   Future<File> saveData(String key, dynamic value) async {
//     final file = await _localFile(key);
//     return file.writeAsString(json.encode(value));
//   }

//   @override
//   Future<dynamic> loadData(String key) async {
//     try {
//       final file = await _localFile(key);
//       final contents = await file.readAsString();
//       return json.decode(contents);
//     } catch (e) {
//       return null;
//     }
//   }
// }
