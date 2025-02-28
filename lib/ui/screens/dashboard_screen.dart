import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/providers/task_notifier.dart';
import '../widgets/task_item.dart';
import '../widgets/task_statistics.dart';
import '../widgets/add_task_dialog.dart';
import 'task_list_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskProvider);
    final tasks = taskState.tasks;
    
    // Get today and upcoming tasks
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final todayTasks = tasks.where((task) => 
      !task.isCompleted && 
      task.dueDate != null && 
      DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day) == today
    ).toList();
    
    final upcomingTasks = tasks.where((task) => 
      !task.isCompleted && 
      task.dueDate != null && 
      task.dueDate!.isAfter(today) &&
      task.dueDate!.difference(today).inDays <= 7 // Next 7 days
    ).toList();
    
    final overdueTasks = tasks.where((task) => 
      !task.isCompleted && 
      task.dueDate != null && 
      task.dueDate!.isBefore(today)
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Obsidian'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskListScreen()),
              );
            },
            tooltip: 'View All Tasks',
          ),
        ],
      ),
      body: taskState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(taskProvider.notifier).loadTasks();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TaskStatistics(),
                    
                    _buildTaskSection(
                      context,
                      'Today',
                      todayTasks,
                      Colors.blue,
                      Icons.today,
                    ),
                    
                    if (overdueTasks.isNotEmpty)
                      _buildTaskSection(
                        context,
                        'Overdue',
                        overdueTasks,
                        Colors.red,
                        Icons.warning,
                      ),
                    
                    _buildTaskSection(
                      context,
                      'Upcoming (Next 7 Days)',
                      upcomingTasks,
                      Colors.green,
                      Icons.date_range,
                    ),
                    
                    const SizedBox(height: 80), // Space for FAB
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTaskSection(
    BuildContext context,
    String title,
    List<dynamic> tasks,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: color,
                  width: 4,
                ),
              ),
            ),
            child: tasks.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No ${title.toLowerCase()} tasks',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length > 3 ? 3 : tasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(task: tasks[index]);
                    },
                  ),
          ),
          if (tasks.length > 3)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TaskListScreen()),
                  );
                },
                child: const Text('View all tasks'),
              ),
            ),
        ],
      ),
    );
  }
}