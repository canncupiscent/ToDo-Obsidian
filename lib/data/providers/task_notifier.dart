import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  void addTask(Task task) {
    state = [...state, task];
  }

  void toggleTask(Task task) {
    state = state.map((t) => 
      t.id == task.id ? task.copyWith(isCompleted: !task.isCompleted) : t
    ).toList();
  }

  void deleteTask(Task task) {
    state = state.where((t) => t.id != task.id).toList();
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});