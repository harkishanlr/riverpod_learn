import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_learn/screens/splash/splash_screen.dart';
import 'package:riverpod_learn/screens/splash/splash_screen.dart';
import 'package:riverpod_learn/screens/user/ui/login/login_screen.dart';
import 'package:riverpod_learn/utils/hive_db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDbService.initializeHive();
  await Hive.openBox(HiveDbService.userBox);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }


}
