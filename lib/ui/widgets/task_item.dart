import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task.dart';
import '../../data/providers/task_notifier.dart';

class TaskItem extends ConsumerWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(task.id.toString()),
      onDismissed: (_) {
        ref.read(taskProvider.notifier).deleteTask(task);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) {
            ref.read(taskProvider.notifier).toggleTask(task);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description != null ? Text(task.description!) : null,
        trailing: task.dueDate != null
            ? Text(
                '${task.dueDate!.day}/${task.dueDate!.month}',
                style: const TextStyle(color: Colors.grey),
              )
            : null,
      ),
    );
  }
}