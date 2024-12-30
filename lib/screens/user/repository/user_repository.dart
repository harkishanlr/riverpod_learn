import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/utils/api_service.dart';

const baseUrl = "https://dummyjson.com/auth/";

const loginEndpoint = "login";

class UserRepository {
     Future<Map<String, dynamic>> login(
      String userName, String password) async {
    final result = await ApiService(baseUrl: baseUrl).post(
      loginEndpoint,
      body: {
        "username": userName,
        "password": password,
      },
    );
    return result;
  }
}


final authRepositoryProvider = Provider((ref) => UserRepository());
