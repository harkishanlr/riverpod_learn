import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// 1. Time Stream
Stream<String> timeStream() {
  return Stream.periodic(const Duration(seconds: 1), (_) {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  });
  //return Stream.error(Exception('Error from stream'));
}

// 2. StreamProvider
final timeProvider = StreamProvider<String>((ref) {
  return timeStream();
});

// 3. UI Components
class TimeDisplay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeAsync = ref.watch(timeProvider);

    return timeAsync.when(
      data: (time) => Text(
        'Current Time: $time',
        style: const TextStyle(fontSize: 24),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}

// 4. Main App
class StreamProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Time Stream App')),
        body: Center(
          child: TimeDisplay(),
        ),
      ),
    );
  }
}
