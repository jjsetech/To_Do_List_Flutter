import 'package:flutter/material.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = MyApp.themeNotifier.value == ThemeMode.dark;
  }

  Future<void> _toggleTheme(bool value) async {
    setState(() {
      _isDarkTheme = value;
    });
    await MyApp.toggleTheme(value); // Save and change the theme globally
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Developed by Jeronimo Junior',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'JJ Studio Entertainment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Version 1.0',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 40),
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: _isDarkTheme,
            onChanged: _toggleTheme,
          ),
        ],
      ),
    );
  }
}
