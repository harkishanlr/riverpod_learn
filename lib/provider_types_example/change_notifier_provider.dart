import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Todo Model
class Todo {
  final String id;
  final String title;

  Todo({required this.id, required this.title});
}

// 2. Todo State (Notifier)
class TodoNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return []; // Initial state is an empty list
  }

  void addTodo(String title) {
    state = [
      ...state,
      Todo(id: DateTime.now().toString(), title: title),
    ];
  }

  void removeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}
// We can use AutoDisposeNotifier to automatically dispose when it's not in use
// class TodoNotifier extends AutoDisposeNotifier<List<Todo>> {
//   @override
//   List<Todo> build() {
//     return []; // Initial state is an empty list
//   }
//
//   void addTodo(String title) {
//     state = [
//       ...state,
//       Todo(id: DateTime.now().toString(), title: title),
//     ];
//   }
//
//   void removeTodo(String id) {
//     state = state.where((todo) => todo.id != id).toList();
//   }
// }
// 3. NotifierProvider
final todoProvider = NotifierProvider<TodoNotifier, List<Todo>>(() {
  return TodoNotifier();
});

// 4. UI Components
class TodoList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ListTile(
          title: Text(todo.title),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(todoProvider.notifier).removeTodo(todo.id);
            },
          ),
        );
      },
    );
  }
}

class TodoInput extends ConsumerWidget {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Add Todo')
            ),
          ),
          IconButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                ref
                    .read(todoProvider.notifier)
                    .addTodo(_textController.text);
                _textController.clear();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

// 5. Main App
class NotifierProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Todo List')),
        body: Column(
          children: [
            TodoInput(),
            Expanded(child: TodoList()),
          ],
        ),
      ),
    );
  }
}

