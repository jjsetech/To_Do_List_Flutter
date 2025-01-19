class TodoItem {
  final String id;
  final String title;
  final bool isDone;

  TodoItem({required this.id, required this.title, this.isDone = false});

  // Convert a TodoItem to a JSON-like map
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isDone': isDone,
  };

  // Create a TodoItem from a JSON-like map
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'],
    );
  }
}
