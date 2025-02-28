import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/bottom_nav_screen.dart';
import '../core/themes/app_theme.dart';
import '../data/providers/settings_provider.dart';

class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    
    return MaterialApp(
      title: 'Todo Obsidian',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      home: const BottomNavScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}