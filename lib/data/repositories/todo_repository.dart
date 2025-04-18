import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:simpl/app/constants.dart';
import 'package:simpl/data/models/todo_model.dart';
import 'package:simpl/data/providers/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final bool useDummyData = true; // Set to false for real API calls

  // Get all todos
  Future<List<Todo>> getAllTodos() async {
    // if (useDummyData) {
    //   return _generateDummyTodos();
    // }

    try {
      final response = await _apiProvider.get(Constants.todos);
      final data = response.data['data'];

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
    // if (useDummyData) {
    //   // return _generateDummyTodos().firstWhere((todo) => todo.id == id);
    // }

    try {
      final response = await _apiProvider.get('${Constants.todos}/$id');
      return Todo.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get todo: ${e.toString()}');
    }
  }

  // Create todo
  Future<Todo> createOrder(todo) async {
    try {
      final response = await _apiProvider.post(
        Constants.parcels,
        data: todo.toJson(),
      );
      return Todo.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create todo: ${e.toString()}');
    }
  }

  // Update todo
  Future<Todo> updateTodo(Todo todo) async {
    if (useDummyData) {
      return todo;
    }

    try {
      if (todo.id == null) {
        throw Exception('Todo ID is required for update');
      }

      final response = await _apiProvider.put(
        '${Constants.todos}/${todo.id}',
        data: todo.toJson(),
      );
      return Todo.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update todo: ${e.toString()}');
    }
  }

  // Delete todo
  Future<bool> deleteTodo(int id) async {
    if (useDummyData) {
      return true;
    }

    try {
      final response = await _apiProvider.delete('${Constants.todos}/$id');
      return true;
    } catch (e) {
      throw Exception('Failed to delete todo: ${e.toString()}');
    }
  }

  // Toggle todo completion
  Future<Todo> toggleTodoCompletion(Todo todo) async {
    if (useDummyData) {
      return todo.copyWith(isShipped: !todo.isShipped);
    }

    try {
      if (todo.id == null) {
        throw Exception('Todo ID is required');
      }

      Todo updatedTodo = todo.copyWith(isShipped: !todo.isShipped);
      final response = await _apiProvider.put(
        '${Constants.todos}/${todo.id}',
        data: updatedTodo.toJson(),
      );
      return Todo.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to toggle todo: ${e.toString()}');
    }
  }

  // Dummy data generator
  // List<Todo> _generateDummyTodos() {
  //   final now = DateTime.now();
  //   const services = ['Express Shipping', 'Standard Delivery', 'International Priority'];
  //   const countries = ['US', 'UK', 'CA', 'AU', 'BR', 'DE', 'FR'];
  //   const recipients = [
  //     'John Smith',
  //     'Emma Johnson',
  //     'Michael Brown',
  //     'Sarah Wilson',
  //     'David Lee',
  //     'Lisa Garcia',
  //     'Robert Martinez'
  //   ];
  //
  //   return List.generate(15, (index) {
  //     final random = DateTime.now().millisecondsSinceEpoch + index;
  //     final daysAgo = random % 30;
  //
  //     return Todo(
  //       id: index + 1,
  //       title: 'Order ${index + 1001}',
  //       description: 'Package containing ${['electronics', 'clothing', 'books', 'documents'][random % 4]}',
  //       isShipped: random % 5 == 0,
  //       createdAt: now.subtract(Duration(days: daysAgo)),
  //       trackingCode: 'TRK${(now.millisecondsSinceEpoch + index).toString().substring(5)}',
  //       serviceName: services[random % services.length],
  //       weight: 0.5 + (random % 10) * 0.3,
  //       orderDate: now.subtract(Duration(days: daysAgo + 1)),
  //       orderValue: 10.0 + (random % 90) * 0.5,
  //       recipientName: recipients[random % recipients.length],
  //       recipientCountry: countries[random % countries.length],
  //     );
  //   });
  // }
}