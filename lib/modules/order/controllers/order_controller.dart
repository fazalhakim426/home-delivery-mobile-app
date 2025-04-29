import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/models/order_model.dart';
import 'package:simpl/data/repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _orderRepository;

  OrderController({required OrderRepository orderRepository})
    : _orderRepository = orderRepository;

  final isLoading = false.obs;
  final orders = <Order>[].obs;

  // Text controllers for adding/editing orders
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Selected todo for editing
  final selectedOrder = Rxn<Order>();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }


  // Fetch all orders
  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final todoList = await _orderRepository.getAllOrders();
      orders.assignAll(todoList);
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error',
        'Failed to fetch orders: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Add new todo
  Future<void> addOrder() async {
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
      // final newOrder =
      // Order(
      //   title: titleController.text,
      //   description: descriptionController.text,
      // );
      //
      // final createdOrder = await _orderRepository.createOrder(newOrder);
      // orders.add(createdOrder);
      // clearForm();
      // Get.back(); // Close the add todo dialog/screen
      // Get.snackbar(
      //   'Success',
      //   'Order added successfully',
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
  Future<void> updateOrder() async {
    if (selectedOrder.value == null) {
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
      final updatedOrder = selectedOrder.value!.copyWith(
        title: titleController.text,
        description: descriptionController.text,
      );

      final result = await _orderRepository.updateOrder(updatedOrder);

      // Update todo in the list
      final index = orders.indexWhere((todo) => todo.id == result.id);
      if (index != -1) {
        orders[index] = result;
      }

      clearForm();

      Get.back(); // Close the edit todo dialog/screen
      Get.snackbar(
        'Success',
        'Order updated successfully',
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
      selectedOrder.value = null;
    }
  }

  // Delete todo
  Future<void> deleteOrder(int id) async {
    isLoading.value = true;
    try {
      final success = await _orderRepository.deleteOrder(id);

      if (success) {
        orders.removeWhere((todo) => todo.id == id);
        Get.snackbar(
          'Success',
          'Order deleted successfully',
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
  Future<void> toggleOrderCompletion(Order todo) async {
    try {
      final updatedOrder = await _orderRepository.toggleOrderCompletion(todo);

      // Update todo in the list
      final index = orders.indexWhere((t) => t.id == updatedOrder.id);
      if (index != -1) {
        orders[index] = updatedOrder;
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
  void selectOrderForEdit(Order todo) {
    selectedOrder.value = todo;
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
      final response = await _orderRepository.createOrder(orderData);
      // Handle response

      Get.back();
      Get.snackbar('Success', 'Order created successfully');
      fetchOrders();
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
  selectedOrder.value = null;
  }
}
