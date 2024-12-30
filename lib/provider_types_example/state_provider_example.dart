import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. StateProvider
final counterProvider = StateProvider<int>((ref) => 0);

// 2. UI Components
class CounterDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return Text(
      'Counter: $counter',
      style: const TextStyle(fontSize: 24),
    );
  }
}

class CounterButtons extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state--;
          },
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

// 3. Main App
class StateProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Counter App')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CounterDisplay(),
              const SizedBox(height: 20),
              CounterButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

