import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final ThemeMode themeMode;
  final bool enableReminders;
  final String? defaultDueTime;
  final String? defaultCategory;
  final int? defaultPriority;

  AppSettings({
    this.themeMode = ThemeMode.system,
    this.enableReminders = true,
    this.defaultDueTime,
    this.defaultCategory,
    this.defaultPriority,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? enableReminders,
    String? defaultDueTime,
    String? defaultCategory,
    int? defaultPriority,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      enableReminders: enableReminders ?? this.enableReminders,
      defaultDueTime: defaultDueTime ?? this.defaultDueTime,
      defaultCategory: defaultCategory ?? this.defaultCategory,
      defaultPriority: defaultPriority ?? this.defaultPriority,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
      'enableReminders': enableReminders,
      'defaultDueTime': defaultDueTime,
      'defaultCategory': defaultCategory,
      'defaultPriority': defaultPriority,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      themeMode: ThemeMode.values[map['themeMode'] ?? 0],
      enableReminders: map['enableReminders'] ?? true,
      defaultDueTime: map['defaultDueTime'],
      defaultCategory: map['defaultCategory'],
      defaultPriority: map['defaultPriority'],
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super(AppSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final themeMode = _prefs.getInt('themeMode') ?? 0;
    final enableReminders = _prefs.getBool('enableReminders') ?? true;
    final defaultDueTime = _prefs.getString('defaultDueTime');
    final defaultCategory = _prefs.getString('defaultCategory');
    final defaultPriorityValue = _prefs.getInt('defaultPriority');
    final defaultPriority = defaultPriorityValue != null ? defaultPriorityValue : null;

    state = AppSettings(
      themeMode: ThemeMode.values[themeMode],
      enableReminders: enableReminders,
      defaultDueTime: defaultDueTime,
      defaultCategory: defaultCategory,
      defaultPriority: defaultPriority,
    );
  }

  Future<void> updateSettings(AppSettings settings) async {
    // Update state
    state = settings;

    // Save to SharedPreferences
    await _prefs.setInt('themeMode', settings.themeMode.index);
    await _prefs.setBool('enableReminders', settings.enableReminders);
    
    if (settings.defaultDueTime != null) {
      await _prefs.setString('defaultDueTime', settings.defaultDueTime!);
    } else {
      await _prefs.remove('defaultDueTime');
    }
    
    if (settings.defaultCategory != null) {
      await _prefs.setString('defaultCategory', settings.defaultCategory!);
    } else {
      await _prefs.remove('defaultCategory');
    }
    
    if (settings.defaultPriority != null) {
      await _prefs.setInt('defaultPriority', settings.defaultPriority!);
    } else {
      await _prefs.remove('defaultPriority');
    }
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Should be overridden in main.dart');
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});