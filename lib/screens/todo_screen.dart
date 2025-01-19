import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_item.dart';
import '../services/local_storage_service.dart';
import '../widgets/todo_item_widget.dart';
import 'settings_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final LocalStorageService _storageService = LocalStorageService();
  List<TodoItem> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final todoData = await _storageService.getTodoList();
    setState(() {
      _todos = todoData.map((e) => TodoItem.fromJson(e)).toList();
    });
  }

  Future<void> _addTodo(String title) async {
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The task cannot be empty!')),
      );
      return;
    }

    setState(() {
      _todos.add(TodoItem(id: const Uuid().v4(), title: title));
    });
    await _storageService.saveTodoList(_todos.map((e) => e.toJson()).toList());
  }

  Future<void> _toggleTodoStatus(String id) async {
    final index = _todos.indexWhere((item) => item.id == id);
    final currentTodo = _todos[index];

    // If the task is completed and the user tries to uncheck it, ask for confirmation
    if (currentTodo.isDone) {
      final shouldUncheck = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text(
              'This task is already marked as completed. Do you really want to unmark it as incomplete?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Cancel
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // Confirm
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );

      // If the user cancels, do nothing
      if (shouldUncheck != true) {
        return;
      }
    }

    // Toggle the completion status
    setState(() {
      _todos[index] = TodoItem(
        id: currentTodo.id,
        title: currentTodo.title,
        isDone: !currentTodo.isDone,
      );
    });

    await _storageService.saveTodoList(_todos.map((e) => e.toJson()).toList());
  }

  Future<void> _deleteTodoItem(String id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Do not delete
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Confirm deletion
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        _todos.removeWhere((item) => item.id == id);
      });
      await _storageService.saveTodoList(_todos.map((e) => e.toJson()).toList());
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          return TodoItemWidget(
            item: _todos[index],
            onToggle: _toggleTodoStatus,
            onDelete: _deleteTodoItem,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final controller = TextEditingController();
              return AlertDialog(
                title: const Text('Add Task'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter task title',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _addTodo(controller.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
