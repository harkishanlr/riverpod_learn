import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class Task {
  final String title;
  final bool isCompleted;

  Task({required this.title, required this.isCompleted});
}

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);
  List<Task> deletedTasks = [];

  void addTask(String title) {
    state = [...state, Task(title: title, isCompleted: false)];
  }

  void toggleCompletion(int index) {
    if (index < 0 || index >= state.length) {
      return;
    }
    final updatedTasks = List<Task>.from(state);
    updatedTasks[index] = Task(
      title: updatedTasks[index].title,
      isCompleted: !updatedTasks[index].isCompleted,
    );
    state = updatedTasks;
  }

  void deleteTask(int index) {
    if (index < 0 || index >= state.length) {
      return;
    }
    deletedTasks.add(state[index]);
    state = state.where((task) => state.indexOf(task) != index).toList();
  }

  void undoDelete() {
    if (deletedTasks.isNotEmpty) {
      state = [...state, deletedTasks.last];
      deletedTasks.removeLast();
    }
  }
}

final tasksProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.isCompleted).toList();
});
final activeTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => !task.isCompleted).toList();
});

final showCompletedProvider = StateProvider<bool>((ref) => false);

class ProviderExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTasks = ref.watch(activeTasksProvider);
    final completedTasks = ref.watch(completedTasksProvider);
    final showCompleted = ref.watch(showCompletedProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Task Manager"),
          actions: [
            Row(
              children: [
                Text("Show Completed"),
                Radio<bool>(
                  value: true,
                  groupValue: showCompleted,
                  onChanged: (value) {
                    ref.read(showCompletedProvider.notifier).state = value!;
                  },
                ),
                Text("Show Active"),
                Radio<bool>(
                  value: false,
                  groupValue: showCompleted,
                  onChanged: (value) {
                    ref.read(showCompletedProvider.notifier).state = value!;
                  },
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.undo),
              onPressed: () {
                ref.read(tasksProvider.notifier).undoDelete();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount:
                    showCompleted ? completedTasks.length : activeTasks.length,
                itemBuilder: (context, index) {
                  final task = showCompleted
                      ? completedTasks[index]
                      : activeTasks[index];
                  final mainTaskIndex = ref.read(tasksProvider).indexOf(task);
                  return ListTile(
                    title: Text(task.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(task.isCompleted
                              ? Icons.check_circle
                              : Icons.circle),
                          onPressed: () {
                            ref
                                .read(tasksProvider.notifier)
                                .toggleCompletion(mainTaskIndex);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            ref
                                .read(tasksProvider.notifier)
                                .deleteTask(mainTaskIndex);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref
                .read(tasksProvider.notifier)
                .addTask("New Task ${DateTime.now()}");
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
