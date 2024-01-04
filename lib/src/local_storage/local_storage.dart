abstract class LocalStorageService {
  Future<void> saveData(String key, dynamic value);
  Future<dynamic> loadData(String key);
}
