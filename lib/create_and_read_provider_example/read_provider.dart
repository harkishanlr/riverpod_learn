import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Create a provider
final helloWorldProvider = Provider<String>((_) {
  return 'Hello world';
});

// Below is for stateless widget

class HelloWorldWidgetReadingProviderExample extends StatelessWidget {
  const HelloWorldWidgetReadingProviderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // 1. Add a Consumer
      body: Consumer(
        // 2. specify the builder and obtain a WidgetRef
        builder: (_, WidgetRef ref, __) {
          // 3. use ref.watch() to get the value of the provider
          final helloWorld = ref.watch(helloWorldProvider);
          return Text(helloWorld);
        },
      ),
    );
  }
}

// below is for stateful widget

class HelloWorldWidgetReadingProviderExample1 extends ConsumerStatefulWidget {
  const HelloWorldWidgetReadingProviderExample1({super.key});

  @override
  ConsumerState<HelloWorldWidgetReadingProviderExample1> createState() =>
      _HelloWorldWidgetReadingProviderExample1State();
}

class _HelloWorldWidgetReadingProviderExample1State
    extends ConsumerState<HelloWorldWidgetReadingProviderExample1> {
  @override
  void initState() {
    // 1. use ref.read() to get the value of the provider
    final helloWorld = ref.read(helloWorldProvider);
    print(helloWorld);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 4. use ref.watch() to get the value of the provider
    final helloWorld = ref.watch(helloWorldProvider);
    return Text(helloWorld);
  }
}
