import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static const String _todoKey = 'todo_list';
  static const String _bgColorKey = 'background_color';

  Future<List<Map<String, dynamic>>> getTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_todoKey);
    return data != null ? List<Map<String, dynamic>>.from(json.decode(data)) : [];
  }

  Future<void> saveTodoList(List<Map<String, dynamic>> todos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_todoKey, json.encode(todos));
  }

  Future<int> getBackgroundColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bgColorKey) ?? Colors.white.value;
  }

  Future<void> saveBackgroundColor(int colorValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bgColorKey, colorValue);
  }
}
