import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/task.dart';
import '../../data/providers/task_notifier.dart';

class TaskStatistics extends ConsumerWidget {
  const TaskStatistics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskProvider);
    final tasks = taskState.tasks;
    
    // Calculate statistics
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final pendingTasks = totalTasks - completedTasks;
    
    // Calculate tasks due today
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueToday = tasks.where((task) => 
      task.dueDate != null && 
      DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day) == today &&
      !task.isCompleted
    ).length;
    
    // Calculate overdue tasks
    final overdueTasks = tasks.where((task) => 
      task.dueDate != null && 
      task.dueDate!.isBefore(today) &&
      !task.isCompleted
    ).length;
    
    // Calculate completion rate
    final completionRate = totalTasks > 0 ? (completedTasks / totalTasks * 100).toStringAsFixed(0) : '0';
    
    // Group tasks by priority
    final priorityDistribution = <int, int>{};
    for (final task in tasks) {
      if (task.priority != null) {
        priorityDistribution[task.priority!] = (priorityDistribution[task.priority!] ?? 0) + 1;
      }
    }
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  Icons.task_alt,
                  totalTasks.toString(),
                  'Total',
                  Colors.blue,
                ),
                _buildStatItem(
                  context,
                  Icons.check_circle,
                  completedTasks.toString(),
                  'Completed',
                  Colors.green,
                ),
                _buildStatItem(
                  context,
                  Icons.pending_actions,
                  pendingTasks.toString(),
                  'Pending',
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  Icons.today,
                  dueToday.toString(),
                  'Due Today',
                  Colors.purple,
                ),
                _buildStatItem(
                  context,
                  Icons.warning,
                  overdueTasks.toString(),
                  'Overdue',
                  Colors.red,
                ),
                _buildStatItem(
                  context,
                  Icons.percent,
                  '$completionRate%',
                  'Completion',
                  Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (totalTasks > 0) ...[              const Text(
                'Completion Progress',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                backgroundColor: Colors.grey[200],
                color: Colors.green,
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 16),
              if (priorityDistribution.isNotEmpty) ...[                const Text(
                  'Priority Distribution',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildPriorityChart(priorityDistribution, totalTasks),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityChart(Map<int, int> priorityDistribution, int totalTasks) {
    const priorityLabels = ['Low', 'Medium', 'High', 'Urgent'];
    const priorityColors = [Colors.green, Colors.blue, Colors.orange, Colors.red];
    
    return Column(
      children: List.generate(
        priorityDistribution.length,
        (index) {
          final priority = priorityDistribution.keys.elementAt(index);
          final count = priorityDistribution[priority]!;
          final percentage = totalTasks > 0 ? count / totalTasks : 0;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: priorityColors[priority],
                ),
                const SizedBox(width: 8),
                Text(
                  priorityLabels[priority],
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[200],
                    color: priorityColors[priority],
                    minHeight: 8,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$count (${(percentage * 100).toStringAsFixed(0)}%)',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}