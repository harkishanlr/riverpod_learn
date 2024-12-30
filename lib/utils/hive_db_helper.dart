import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer'; // Import for logging

class HiveDbService {
  static const String userBox = 'userBox';

  // Initialize Hive
  static Future<void> initializeHive() async {
    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      log('Hive initialized at: ${appDocumentDir.path}');
    } catch (e) {
      log('Error initializing Hive: $e');
      throw Exception('Error initializing Hive: $e');
    }
  }

  // Open a box
  Future<Box> openBox(String boxName) async {
    try {
      log('Opening box: $boxName');
      if (!Hive.isBoxOpen(boxName)) {
        final box = await Hive.openBox(boxName);
        log('Box opened: $boxName');
        return box;
      }
      return Hive.box(boxName);
    } catch (e) {
      log('Error opening box $boxName: $e');
      throw Exception('Error opening box: $e');
    }
  }

  // Add data to a box
  Future<void> addData(String boxName, dynamic key, dynamic value) async {
    try {
      log('Adding data to $boxName: key=$key, value=$value');
      final box = await openBox(boxName);
      await box.put(key, value);
      log('Data added to $boxName: key=$key, value=$value');
    } catch (e) {
      log('Error adding data to $boxName: $e');
      throw Exception('Error adding data: $e');
    }
  }

  // Get data from a box
  Future<dynamic> getData(String boxName, dynamic key) async {
    try {
      log('Retrieving data from $boxName: key=$key');
      final box = await openBox(boxName);
      final value = box.get(key);
      log('Data retrieved from $boxName: key=$key, value=$value');
      return value;
    } catch (e) {
      log('Error retrieving data from $boxName: $e');
      throw Exception('Error retrieving data: $e');
    }
  }

  // Get all data from a box
  Future<List<dynamic>> getAllData(String boxName) async {
    try {
      log('Retrieving all data from $boxName');
      final box = await openBox(boxName);
      final values = box.values.toList();
      log('All data retrieved from $boxName: $values');
      return values;
    } catch (e) {
      log('Error retrieving all data from $boxName: $e');
      throw Exception('Error retrieving all data: $e');
    }
  }

  // Delete data from a box
  Future<void> deleteData(String boxName, dynamic key) async {
    try {
      log('Deleting data from $boxName: key=$key');
      final box = await openBox(boxName);
      await box.delete(key);
      log('Data deleted from $boxName: key=$key');
    } catch (e) {
      log('Error deleting data from $boxName: $e');
      throw Exception('Error deleting data: $e');
    }
  }

  // Clear all data from a box
  Future<void> clearBox(String boxName) async {
    try {
      log('Clearing box: $boxName');
      final box = await openBox(boxName);
      await box.clear();
      log('Box cleared: $boxName');
    } catch (e) {
      log('Error clearing box $boxName: $e');
      throw Exception('Error clearing box: $e');
    }
  }

  // Close a box
  Future<void> closeBox(String boxName) async {
    try {
      log('Closing box: $boxName');
      final box = Hive.box(boxName);
      await box.close();
      log('Box closed: $boxName');
    } catch (e) {
      log('Error closing box $boxName: $e');
      throw Exception('Error closing box: $e');
    }
  }

  // Delete a box from disk
  Future<void> deleteBox(String boxName) async {
    try {
      log('Deleting box from disk: $boxName');
      await Hive.deleteBoxFromDisk(boxName);
      log('Box deleted from disk: $boxName');
    } catch (e) {
      log('Error deleting box $boxName: $e');
      throw Exception('Error deleting box: $e');
    }
  }

  // Set token in box
  Future<void> setToken(String token) async {
    try {
      log('Setting token in box: $token');
      await addData(userBox, 'token', token);
      log('Token set: $token');
    } catch (e) {
      log('Error setting token: $e');
      throw Exception('Error setting token: $e');
    }
  }

  // Get token from box
  Future<String?> getToken() async {
    try {
      log('Retrieving token from box');
      final token = await getData(userBox, 'token');
      log('Token retrieved: $token');
      return token;
    } catch (e) {
      log('Error retrieving token: $e');
      return null;
    }
  }

  // Delete user box
  Future<void> deleteUserBox() async {
    try {
      log('Deleting user box');
      await deleteBox(userBox);
      log('User box deleted');
    } catch (e) {
      log('Error deleting user box: $e');
      throw Exception('Error deleting user box: $e');
    }
  }
}

final hiveDbHelperProvider = Provider((ref) => HiveDbService());
