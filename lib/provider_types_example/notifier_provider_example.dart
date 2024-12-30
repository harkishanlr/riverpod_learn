import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Theme State (ChangeNotifier)
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// 2. ChangeNotifierProvider
final themeProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier();
});

// 3. UI Components
class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    return IconButton(
      icon: Icon(
        themeNotifier.themeMode == ThemeMode.light
            ? Icons.light_mode
            : Icons.dark_mode,
      ),
      onPressed: () {
        ref.read(themeProvider.notifier).toggleTheme();
      },
    );
  }
}

class ChangeNotifierProviderExample extends ConsumerWidget {
  const ChangeNotifierProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Switcher'),
          actions: const [ThemeSwitcher()],
        ),
        body: Consumer(builder: (context, ref, child) {
          return Center(child: Text('Theme: ${themeNotifier.themeMode.name}'));
        }),
      ),
    );
  }
}
