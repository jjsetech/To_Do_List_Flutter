import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/todo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeMode = await _loadThemePreference();
  runApp(MyApp(themeMode: themeMode));
}

Future<ThemeMode> _loadThemePreference() async {
  final prefs = await SharedPreferences.getInstance();
  final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
  // Always return a valid value (ThemeMode.light or ThemeMode.dark)
  return isDarkTheme ? ThemeMode.dark : ThemeMode.light;
}

Future<void> _saveThemePreference(bool isDarkTheme) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isDarkTheme', isDarkTheme);
}

class MyApp extends StatelessWidget {
  final ThemeMode themeMode;

  MyApp({Key? key, required this.themeMode}) : super(key: key);

  // Global controller for the theme
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    themeNotifier.value = themeMode; // Sets initial theme based on saved preference

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'To-Do List',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
          ),
          themeMode: currentMode, // Aplica o tema atual
          home: const TodoScreen(),
        );
      },
    );
  }

  // Switch the theme and save the preference
  static Future<void> toggleTheme(bool isDarkTheme) async {
    themeNotifier.value = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    await _saveThemePreference(isDarkTheme); // Save theme preference
  }
}
