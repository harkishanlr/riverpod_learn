abstract class DatabaseService {
  Future<void> initialize();

  Future<void> addData(String boxName, dynamic key, dynamic value);

  Future<dynamic> getData(String boxName, dynamic key);

  Future<List<dynamic>> getAllData(String boxName);

  Future<void> deleteData(String boxName, dynamic key);

  Future<void> clearBox(String boxName);

  Future<void> closeBox(String boxName);

  Future<void> deleteBox(String boxName);
}
