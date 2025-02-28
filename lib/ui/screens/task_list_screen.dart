import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/task_notifier.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_dialog.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends ConsumerState<TaskListScreen> {
  final _searchController = TextEditingController();
  bool _showCompletedTasks = true;
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);
    final filteredTasks = taskState.tasks.where((task) => 
      _showCompletedTasks || !task.isCompleted
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Obsidian'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(taskProvider.notifier).searchTasks('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                ref.read(taskProvider.notifier).searchTasks(value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_selectedCategory != null || !_showCompletedTasks)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text('Filters: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  if (_selectedCategory != null)
                    Chip(
                      label: Text('Category: $_selectedCategory'),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _selectedCategory = null;
                        });
                        ref.read(taskProvider.notifier).filterByCategory(null);
                      },
                    ),
                  const SizedBox(width: 8),
                  if (!_showCompletedTasks)
                    const Chip(
                      label: Text('Active tasks only'),
                    ),
                ],
              ),
            ),
          Expanded(
            child: taskState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.task_alt, size: 80, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'No tasks match your search'
                                  : _selectedCategory != null
                                      ? 'No tasks in this category'
                                      : 'No tasks yet!',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Add Your First Task'),
                              onPressed: _showAddTaskDialog,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          return TaskItem(task: filteredTasks[index]);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: filteredTasks.isNotEmpty
          ? FloatingActionButton(
              onPressed: _showAddTaskDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );
  }

  void _showFilterDialog() async {
    final categories = await ref.read(taskProvider.notifier).getCategories();
    
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Filter Tasks'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  title: const Text('Show completed tasks'),
                  value: _showCompletedTasks,
                  onChanged: (value) {
                    setState(() {
                      _showCompletedTasks = value ?? true;
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (categories.isNotEmpty) ...[                  const Text('Filter by category:'),
                  const SizedBox(height: 8),
                  DropdownButton<String?>(
                    value: _selectedCategory,
                    hint: const Text('All categories'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All categories'),
                      ),
                      ...categories.map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Update external state
                  this.setState(() {});
                  ref.read(taskProvider.notifier).filterByCategory(_selectedCategory);
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }
}