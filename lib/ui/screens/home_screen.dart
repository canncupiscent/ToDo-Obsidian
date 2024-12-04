import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Obsidian'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to Todo Obsidian!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add task
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}