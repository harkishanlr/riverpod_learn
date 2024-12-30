import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_learn/local_db_helper/hive_db_helper.dart';
import 'package:riverpod_learn/screens/user/ui/login/login_screen.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              _showLogoutConfirmationDialog(context, ref);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the dashboard'),
      ),
    );
  }

  Future<void> _showLogoutConfirmationDialog(
      BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when canceled
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if confirmed
              },
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      _performLogout(context, ref);
    }
  }

  Future<void> _performLogout(BuildContext context, WidgetRef ref) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await _clearHiveData();
      // Close the loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      // Handle errors
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Logout failed: $e')));
      }
    }
  }

  Future<void> _clearHiveData() async {
    await HiveDbService().deleteUserBox();
    await Future.delayed(const Duration(seconds: 3));
  }
}
