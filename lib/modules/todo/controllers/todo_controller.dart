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


  // Fetch all todos
  Future<void> fetchTodos() async {
    isLoading.value = true;
    try {
      final todoList = await _todoRepository.getAllTodos();
      todos.assignAll(todoList);
    } catch (e) {
      print(e.toString());
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




  // Add these new controllers
  final trackingIdController = TextEditingController();
  final customerReferenceController = TextEditingController();
  final weightController = TextEditingController();
  final shipmentValueController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final senderNameController = TextEditingController();
  final senderEmailController = TextEditingController();
  final recipientNameController = TextEditingController();
  final recipientEmailController = TextEditingController();
  final recipientPhoneController = TextEditingController();

  @override
  void onClose() {
  // Dispose all controllers
  trackingIdController.dispose();
  customerReferenceController.dispose();
  weightController.dispose();
  shipmentValueController.dispose();
  lengthController.dispose();
  widthController.dispose();
  heightController.dispose();
  senderNameController.dispose();
  senderEmailController.dispose();
  recipientNameController.dispose();
  recipientEmailController.dispose();
  recipientPhoneController.dispose();
  super.onClose();
  }

  Future<void> createOrder() async {
  if (titleController.text.isEmpty || trackingIdController.text.isEmpty) {
  Get.snackbar('Error', 'Required fields are missing');
  return;
  }


  isLoading.value = true;
  try {
  final orderData = {
  "parcel": {
  "service_id": 1,
  "merchant": "John",
  "carrier": "Carrier",
  "tracking_id": trackingIdController.text,
  "customer_reference": customerReferenceController.text,
  "measurement_unit": "kg/cm",
  "weight": weightController.text,
  "length": lengthController.text,
  "width": widthController.text,
  "height": heightController.text,
  "tax_modality": "DDU",
  "shipment_value": shipmentValueController.text,
  },
  "sender": {
  "sender_first_name": senderNameController.text.split(' ').first,
  "sender_last_name": senderNameController.text.split(' ').length > 1
  ? senderNameController.text.split(' ').last
      : '',
  "sender_email": senderEmailController.text,
  "sender_taxId": "32786897807",
  "sender_country_id": "US",
  "sender_website": "https://dev.homedeliverybr.com"
  },
  "recipient": {
  "first_name": recipientNameController.text.split(' ').first,
  "last_name": recipientNameController.text.split(' ').length > 1
  ? recipientNameController.text.split(' ').last
        : '',
    "email": recipientEmailController.text,
    "phone": recipientPhoneController.text,
    "tax_id": "73489158172",
    "city": "Brasilia",
    "street_no": "0",
    "address": "Sample Address",
    "address2": "",
    "account_type": "individual",
    "zipcode": "71680389",
    "state_id": "509",
    "country_id": 30
  },
    "products": [
      {
        "sh_code": "61019090",
        "description": titleController.text,
        "quantity": 1,
        "value": shipmentValueController.text,
        "is_battery": 0,
        "is_perfume": 0,
        "is_flameable": 0
      }
    ]
  };

  // Call your API to create the order
  final response = await _todoRepository.createOrder(orderData);
  // Handle response

  Get.back();
  Get.snackbar('Success', 'Order created successfully');
  fetchTodos();
  } catch (e) {
  Get.snackbar('Error', 'Failed to create order: ${e.toString()}');
  } finally {
  isLoading.value = false;
  }
  }

  void clearForm() {
  titleController.clear();
  descriptionController.clear();
  trackingIdController.clear();
  customerReferenceController.clear();
  weightController.clear();
  shipmentValueController.clear();
  lengthController.clear();
  widthController.clear();
  heightController.clear();
  senderNameController.clear();
  senderEmailController.clear();
  recipientNameController.clear();
  recipientEmailController.clear();
  recipientPhoneController.clear();
  selectedTodo.value = null;
  }
}
