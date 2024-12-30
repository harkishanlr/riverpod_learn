import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. User Model
class User {
  final String name;
  final String email;
  final String city;

  User({required this.name, required this.email, required this.city});
}

// 2. Mock Async API
Future<User> fetchUser() async {
  await Future.delayed(const Duration(seconds: 3)); // Simulate API delay
  return User(
      name: 'John Doe', email: 'john.doe@example.com', city: 'New York');
  // throw Exception('Failed to fetch user'); // Uncomment to test error handling
}

// 3. User State (AsyncNotifier)
class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    return await fetchUser();
  }
}

// 4. AsyncNotifierProvider
final userProvider =
    AsyncNotifierProvider<UserNotifier, User>(() => UserNotifier());
// We can use AutoDisposeAsyncNotifier to automatically dispose when it's not in use
// final userProvider =
//     AutoDisposeAsyncNotifierProvider<UserNotifier, User>(() => UserNotifier());

// 5. UI Components
class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}', style: const TextStyle(fontSize: 20)),
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 16)),
            Text('City: ${user.city}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}

// 6. Main App
class AsyncNotifierProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('User Profile')),
        body: UserProfile(),
      ),
    );
  }
}
