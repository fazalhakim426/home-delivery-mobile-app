import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/models/todo_model.dart';
import 'package:simpl/data/repositories/todo_repository.dart';

class TodoController extends GetxController {
  final TodoRepository _todoRepository;

  TodoController({required TodoRepository todoRepository})
    : _todoRepository = todoRepository;

  final isLoading = false.obs;
  final todos = <Todo>[].obs;

  // Text controllers for adding/editing todos
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Selected todo for editing
  final selectedTodo = Rxn<Todo>();

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Fetch all todos
  Future<void> fetchTodos() async {
    isLoading.value = true;
    try {
      final todoList = await _todoRepository.getAllTodos();
      todos.assignAll(todoList);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch todos: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add new todo
  Future<void> addTodo() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Title and description are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      // final newTodo =
      // Todo(
      //   title: titleController.text,
      //   description: descriptionController.text,
      // );
      //
      // final createdTodo = await _todoRepository.createTodo(newTodo);
      // todos.add(createdTodo);
      // clearForm();
      // Get.back(); // Close the add todo dialog/screen
      // Get.snackbar(
      //   'Success',
      //   'Todo added successfully',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add todo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update todo
  Future<void> updateTodo() async {
    if (selectedTodo.value == null) {
      Get.snackbar(
        'Error',
        'No todo selected for update',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Title and description are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final updatedTodo = selectedTodo.value!.copyWith(
        title: titleController.text,
        description: descriptionController.text,
      );

      final result = await _todoRepository.updateTodo(updatedTodo);

      // Update todo in the list
      final index = todos.indexWhere((todo) => todo.id == result.id);
      if (index != -1) {
        todos[index] = result;
      }

      clearForm();
      Get.back(); // Close the edit todo dialog/screen
      Get.snackbar(
        'Success',
        'Todo updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update todo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      selectedTodo.value = null;
    }
  }

  // Delete todo
  Future<void> deleteTodo(int id) async {
    isLoading.value = true;
    try {
      final success = await _todoRepository.deleteTodo(id);

      if (success) {
        todos.removeWhere((todo) => todo.id == id);
        Get.snackbar(
          'Success',
          'Todo deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete todo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle todo completion
  Future<void> toggleTodoCompletion(Todo todo) async {
    try {
      final updatedTodo = await _todoRepository.toggleTodoCompletion(todo);

      // Update todo in the list
      final index = todos.indexWhere((t) => t.id == updatedTodo.id);
      if (index != -1) {
        todos[index] = updatedTodo;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update todo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Set selected todo for editing
  void selectTodoForEdit(Todo todo) {
    selectedTodo.value = todo;
    titleController.text = todo.title;
    descriptionController.text = todo.description;
  }

  // Clear form
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    selectedTodo.value = null;
  }
}
