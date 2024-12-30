import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/local_db_helper/hive_db_helper.dart';
import 'package:riverpod_learn/screens/dashboard/dashboard.dart';
import 'package:riverpod_learn/screens/user/ui/login/login_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  Future<void> _navigateBasedOnToken(
      BuildContext context, WidgetRef ref) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading time
    final hiveDbService =
        ref.read(hiveDbHelperProvider); // Get HiveDbService instance
    try {
      final token = await hiveDbService.getToken(); // Fetch the token
      if (token != null && token.isNotEmpty) {
        // Navigate to Dashboard if token exists
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } else {
        // Navigate to Login if token is null
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      // Handle errors if necessary
      debugPrint('Error fetching token: $e');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger navigation when SplashScreen builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateBasedOnToken(context, ref);
    });

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Welcome to the app'),
          ],
        ),
      ),
    );
  }
}
