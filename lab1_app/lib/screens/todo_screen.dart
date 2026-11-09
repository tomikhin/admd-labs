import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../api/todo_api.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> _items = [];
  bool _isLoading = true;
  final TodoApi _api = TodoApi();
  final List<String> _retryLogs = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      // Temporaly substitute _api.fetchTodos with _api.fetchInvalid, 
      // in order to test retry-logic with the error 404
      final todos = await _api.withRetry(() => _api.fetchTodos());
      setState(() {
        _items = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _retryLogs.add('Failed to load: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 - Live Todos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_retryLogs.isNotEmpty)
                  Container(
                    color: Colors.red.shade100,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: _retryLogs
                          .map((log) => Text(log, style: const TextStyle(color: Colors.red)))
                          .toList(),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final todo = _items[index];
                      return TodoTile(
                        todo: todo,
                        onChanged: (val) {
                          setState(() {
                            _items[index] = Todo(
                              userId: todo.userId,
                              id: todo.id,
                              title: todo.title,
                              completed: val ?? false,
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class TodoTile extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onChanged;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(todo.title),
        subtitle: Text('User ID: ${todo.userId} | ID: ${todo.id}'),
        trailing: Checkbox(
          value: todo.completed,
          onChanged: onChanged,
        ),
      ),
    );
  }
}