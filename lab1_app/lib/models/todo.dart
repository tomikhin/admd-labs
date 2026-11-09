class Todo {
  final String id = DateTime.now().microsecondsSinceEpoch.toString();
  String title;
  bool done;

  Todo(this.title, {this.done = false});
}