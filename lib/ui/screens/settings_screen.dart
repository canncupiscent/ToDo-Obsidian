import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Appearance
          ListTile(
            title: const Text('Appearance'),
            subtitle: const Text('Customize how the app looks'),
            leading: const Icon(Icons.color_lens),
            onTap: () => _showThemeDialog(context, ref),
          ),

          // Notifications
          SwitchListTile(
            title: const Text('Task Reminders'),
            subtitle: const Text('Get notified about upcoming tasks'),
            secondary: const Icon(Icons.notifications),
            value: settings.enableReminders,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSettings(
                    settings.copyWith(enableReminders: value),
                  );
            },
          ),

          // Default due time
          ListTile(
            title: const Text('Default Due Time'),
            subtitle: Text(settings.defaultDueTime ?? 'Not set'),
            leading: const Icon(Icons.access_time),
            onTap: () => _showTimePickerDialog(context, ref),
          ),

          const Divider(),

          // Default category
          ListTile(
            title: const Text('Default Category'),
            subtitle: Text(settings.defaultCategory ?? 'None'),
            leading: const Icon(Icons.category),
            onTap: () => _showCategoryDialog(context, ref),
          ),

          // Default priority
          ListTile(
            title: const Text('Default Priority'),
            subtitle: Text(_getPriorityLabel(settings.defaultPriority)),
            leading: const Icon(Icons.flag),
            onTap: () => _showPriorityDialog(context, ref),
          ),

          const Divider(),

          // Storage and Data
          ListTile(
            title: const Text('Export Tasks'),
            subtitle: const Text('Backup your tasks as JSON'),
            leading: const Icon(Icons.file_download),
            onTap: () {
              // TODO: Implement export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon')),
              );
            },
          ),

          ListTile(
            title: const Text('Import Tasks'),
            subtitle: const Text('Import tasks from backup'),
            leading: const Icon(Icons.file_upload),
            onTap: () {
              // TODO: Implement import
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Import feature coming soon')),
              );
            },
          ),

          const Divider(),

          // About
          ListTile(
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            leading: const Icon(Icons.info),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  String _getPriorityLabel(int? priority) {
    if (priority == null) return 'None';
    final labels = ['Low', 'Medium', 'High', 'Urgent'];
    return labels[priority];
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Theme'),
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('System Default'),
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(themeMode: value),
                    );
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light Theme'),
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(themeMode: value),
                    );
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark Theme'),
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(themeMode: value),
                    );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showTimePickerDialog(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // ignore: use_build_context_synchronously
      ref.read(settingsProvider.notifier).updateSettings(
            settings.copyWith(defaultDueTime: pickedTime.format(context)),
          );
    }
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    final categories = ['Personal', 'Work', 'Shopping', 'Health', 'Other'];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Default Category'),
        children: [
          RadioListTile<String?>(
            title: const Text('None'),
            value: null,
            groupValue: settings.defaultCategory,
            onChanged: (String? value) {
              ref.read(settingsProvider.notifier).updateSettings(
                    settings.copyWith(defaultCategory: value),
                  );
              Navigator.pop(context);
            },
          ),
          ...categories.map(
            (category) => RadioListTile<String>(
              title: Text(category),
              value: category,
              groupValue: settings.defaultCategory,
              onChanged: (String? value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateSettings(
                        settings.copyWith(defaultCategory: value),
                      );
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPriorityDialog(BuildContext context, WidgetRef ref) {
    final settings = ref.read(settingsProvider);
    final priorityLabels = ['Low', 'Medium', 'High', 'Urgent'];

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Default Priority'),
        children: [
          RadioListTile<int?>(
            title: const Text('None'),
            value: null,
            groupValue: settings.defaultPriority,
            onChanged: (int? value) {
              ref.read(settingsProvider.notifier).updateSettings(
                    settings.copyWith(defaultPriority: value),
                  );
              Navigator.pop(context);
            },
          ),
          ...List.generate(
            priorityLabels.length,
            (index) => RadioListTile<int>(
              title: Text(priorityLabels[index]),
              value: index,
              groupValue: settings.defaultPriority,
              onChanged: (int? value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateSettings(
                        settings.copyWith(defaultPriority: value),
                      );
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About ToDo Obsidian'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A modern Flutter Todo app with clean architecture.'),
            SizedBox(height: 16),
            Text('Version: 1.0.0'),
            Text('© 2025 ToDo Obsidian'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}