import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';

import 'package:riverpod_learn/local_db_helper/hive_db_service.dart';

class HiveDbService extends DatabaseService {
  static const String userBox = 'userBox';

  @override
  Future<void> initialize() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      log('Hive initialized at: ${appDocumentDir.path}');
    } catch (e) {
      log('Error initializing Hive: $e');
      throw Exception('Error initializing Hive: $e');
    }
  }

  Future<Box> _getOrOpenBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  @override
  Future<void> addData(String boxName, dynamic key, dynamic value) async {
    try {
      final box = await _getOrOpenBox(boxName);
      await box.put(key, value);
      log('Data added to $boxName: key=$key, value=$value');
    } catch (e) {
      log('Error adding data to $boxName: $e');
      throw Exception('Error adding data: $e');
    }
  }

  @override
  Future<dynamic> getData(String boxName, dynamic key) async {
    try {
      final box = await _getOrOpenBox(boxName);
      return box.get(key);
    } catch (e) {
      log('Error retrieving data from $boxName: $e');
      throw Exception('Error retrieving data: $e');
    }
  }

  @override
  Future<List<dynamic>> getAllData(String boxName) async {
    try {
      final box = await _getOrOpenBox(boxName);
      return box.values.toList();
    } catch (e) {
      log('Error retrieving all data from $boxName: $e');
      throw Exception('Error retrieving all data: $e');
    }
  }

  @override
  Future<void> deleteData(String boxName, dynamic key) async {
    try {
      final box = await _getOrOpenBox(boxName);
      await box.delete(key);
      log('Data deleted from $boxName: key=$key');
    } catch (e) {
      log('Error deleting data from $boxName: $e');
      throw Exception('Error deleting data: $e');
    }
  }

  @override
  Future<void> clearBox(String boxName) async {
    try {
      final box = await _getOrOpenBox(boxName);
      await box.clear();
      log('Box cleared: $boxName');
    } catch (e) {
      log('Error clearing box $boxName: $e');
      throw Exception('Error clearing box: $e');
    }
  }

  @override
  Future<void> closeBox(String boxName) async {
    try {
      final box = Hive.box(boxName);
      await box.close();
      log('Box closed: $boxName');
    } catch (e) {
      log('Error closing box $boxName: $e');
      throw Exception('Error closing box: $e');
    }
  }

  @override
  Future<void> deleteBox(String boxName) async {
    try {
      await Hive.deleteBoxFromDisk(boxName);
      log('Box deleted from disk: $boxName');
    } catch (e) {
      log('Error deleting box $boxName: $e');
      throw Exception('Error deleting box: $e');
    }
  }

  // User-specific helpers
  Future<void> setToken(String token) async =>
      await addData(userBox, 'token', token);

  Future<String?> getToken() async =>
      await getData(userBox, 'token') as String?;

  Future<void> deleteUserBox() async => await deleteBox(userBox);
}

final hiveDbHelperProvider = Provider<HiveDbService>((ref) => HiveDbService());
