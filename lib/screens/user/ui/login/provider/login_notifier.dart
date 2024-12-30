import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/screens/dashboard/dashboard.dart';
import 'package:riverpod_learn/screens/user/repository/user_repository.dart';
import 'package:riverpod_learn/screens/user/ui/login/states/login_state_model.dart';
import 'package:riverpod_learn/utils/hive_db_helper.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController(this.ref) : super(const LoginStateInitial());

  final Ref ref;

  Future<void> login(
      String email, String password, BuildContext context) async {
    state = const LoginStateLoading();

    try {
      final result =
          await ref.read(authRepositoryProvider).login(email, password);
      final token = result['accessToken'];
      await ref.read(hiveDbHelperProvider).setToken(token);
      state = const LoginStateSuccess();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      }
    } catch (e) {
      state = LoginStateError(e.toString());
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>(
  (ref) {
    return LoginController(ref);
  },
);
