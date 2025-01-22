class ToDo {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final DateTime createdAt;

  ToDo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt
  });
}