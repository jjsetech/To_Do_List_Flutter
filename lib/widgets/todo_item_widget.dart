import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem item;
  final Function(String) onToggle;
  final Function(String) onDelete;

  const TodoItemWidget({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: item.isDone,
        onChanged: (_) => onToggle(item.id),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          decoration: item.isDone ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => onDelete(item.id),
      ),
    );
  }
}
