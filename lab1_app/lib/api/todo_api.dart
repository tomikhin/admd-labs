import 'dart:math';
import 'package:dio/dio.dart';
import '../models/todo.dart';

class TodoApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  ));

  Future<List<Todo>> fetchTodos() async {
    final res = await _dio.get('/todos');
    final raw = res.data as List<dynamic>;
    return raw
        .map((j) => Todo.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  // Method for testing with an incorrect path (error 404 is expected)
  Future<List<Todo>> fetchInvalid() async {
    final res = await _dio.get('/nope');
    final raw = res.data as List<dynamic>;
    return raw
        .map((j) => Todo.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  // Function with retry, exponential backoff and jitter
  Future<T> withRetry<T>(Future<T> Function() op) async {
    for (var i = 0;; i++) {
      try {
        return await op();
      } catch (e) {
        if (i == 4) rethrow; // try 5 times, then give up
        final b = 400 * (1 << i);
        final delay = b + Random().nextInt(b);
        print('Attempt ${i + 1} failed. Retrying in ${delay}ms... Error: $e');
        await Future.delayed(Duration(milliseconds: delay));
      }
    }
  }
}