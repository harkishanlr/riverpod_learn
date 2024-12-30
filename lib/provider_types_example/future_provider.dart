import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

// 1. Post Model
class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});
}

// 2. Mock API (Async Function)
Future<List<Post>> fetchPosts() async {
  await Future.delayed(const Duration(seconds: 3));

  // Mock Data
  return List.generate(5, (index) {
    return Post(
      id: index,
      title: "Post ${index + 1}",
      body: "This is a random body of post ${index + 1}.",
    );
  });
}

// 3. FutureProvider
final postsProvider = FutureProvider<List<Post>>((ref) async {
  return await fetchPosts();
});

// 4. UI Components
class PostList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return postsAsync.when(
      data: (posts) => ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.body),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}

// 5. Main App
class FutureProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Posts')),
        body: PostList(),
      ),
    );
  }
}
