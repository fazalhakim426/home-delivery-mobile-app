import 'package:get/get.dart';
import 'package:simpl/app/constants.dart';
import 'package:simpl/data/models/todo_model.dart';
import 'package:simpl/data/providers/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TodoRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  // Get all todos
  Future<List<Todo>> getAllTodos() async {
    try {

      // final prefs = await SharedPreferences.getInstance();
      // String? token = prefs.getString(Constants.userToken);
      // String? email = prefs.getString(Constants.userData);
      // print(token);
      final response = await _apiProvider.get(Constants.todos);

      // Access the data from Dio's response object
      final data = response.data['data'];

      // Parse the JSON list into Todo objects
      List<Todo> todos = (data as List)
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();

      return todos;
    } catch (e) {
      throw Exception('Failed to get todos: ${e.toString()}');
    }
  }

  // Get todo by id
  Future<Todo> getTodoById(int id) async {
    try {
      final response = await _apiProvider.get('${Constants.todos}/$id');

      // Dummy implementation
      return Todo(
        id: id,
        title: 'Sample Todo',
        description: 'This is a sample todo item',
        isCompleted: false,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get todo: ${e.toString()}');
    }
  }

  // Create todo
  Future<Todo> createTodo(Todo todo) async {
    try {
      final response = await _apiProvider.post(
        Constants.todos,
        data: todo.toJson(),
      );

      // Dummy implementation
      return Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to create todo: ${e.toString()}');
    }
  }

  // Update todo
  Future<Todo> updateTodo(Todo todo) async {
    try {
      if (todo.id == null) {
        throw Exception('Todo ID is required for update');
      }

      final response = await _apiProvider.put(
        '${Constants.todos}/${todo.id}',
        data: todo.toJson(),
      );

      // Dummy implementation
      return todo.copyWith(
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
      );
    } catch (e) {
      throw Exception('Failed to update todo: ${e.toString()}');
    }
  }

  // Delete todo
  Future<bool> deleteTodo(int id) async {
    try {
      final response = await _apiProvider.delete('${Constants.todos}/$id');

      // Dummy implementation
      return true;
    } catch (e) {
      throw Exception('Failed to delete todo: ${e.toString()}');
    }
  }

  // Toggle todo completion
  Future<Todo> toggleTodoCompletion(Todo todo) async {
    try {
      if (todo.id == null) {
        throw Exception('Todo ID is required');
      }

      Todo updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);

      final response = await _apiProvider.put(
        '${Constants.todos}/${todo.id}',
        data: updatedTodo.toJson(),
      );

      // Dummy implementation
      return updatedTodo;
    } catch (e) {
      throw Exception('Failed to toggle todo: ${e.toString()}');
    }
  }
}
