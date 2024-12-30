import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/screens/user/ui/login/provider/login_notifier.dart';
import 'package:riverpod_learn/screens/user/ui/login/states/login_state_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController(text: "emilys");
  TextEditingController passwordController =
      TextEditingController(text: "emilyspass");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email Address',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Consumer(
                  builder: (context, ref, child) {
                    final loginState = ref.watch(loginControllerProvider);

                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: loginState is! LoginStateLoading
                              ? () {
                                  ref
                                      .read(loginControllerProvider.notifier)
                                      .login(emailController.text,
                                          passwordController.text, context);
                                }
                              : null,
                          child: loginState is LoginStateLoading
                              ? const Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : const Text('Login'),
                        ),
                        const SizedBox(height: 10),
                        if (loginState is LoginStateError)
                          const Text(
                            "Something went wrong",
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
