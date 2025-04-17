import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/models/todo_model.dart';
import 'package:simpl/modules/todo/controllers/todo_controller.dart';
import 'package:intl/intl.dart';
class TodoView extends GetView<TodoController> {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.todos.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.indigo),
          );
        }

        if (controller.todos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.list, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No tasks yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Task'),
                  onPressed: () => _showAddEditTodoDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white, //
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.todos.length,
          itemBuilder: (context, index) {
            final todo = controller.todos[index];
            return _buildTodoItem(context, todo);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditTodoDialog(context),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoItem(BuildContext context, Todo todo) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with tracking code and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${todo.warehouseNumber}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.indigo,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: todo.isCompleted ? Colors.green[100] : Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    todo.isCompleted ? "Shipped" : "Not Shipped",
                    style: TextStyle(
                      color: todo.isCompleted ? Colors.green[800] : Colors.orange[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Order details
            Table(
              columnWidths: const {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(2)},
              children: [
                _buildTableRow("Service:", todo.shippingServiceName),
                // _buildTableRow("Carrier:", todo.carrier ?? "Unknown"),
                _buildTableRow("Order Date:", DateFormat('MMM dd, yyyy').format(todo.orderDate)),
                _buildTableRow("Weight:", "${todo.weight} kg"),
                _buildTableRow("Order Value:", "\$${todo.orderValue.toStringAsFixed(2)}"),
                // _buildTableRow("Shipping Cost:", "\$${todo.shippingValue.toStringAsFixed(2)}"),
                _buildTableRow("Total:", "\$${todo.total.toStringAsFixed(2)}"),
                _buildTableRow("Recipient:", "${todo.recipient.firstName} ${todo.recipient.lastName}"),
                _buildTableRow("Country:", todo.recipient.countryIsoCode),
                _buildTableRow("Address:", todo.recipient.address),
              ],
            ),

            // Products section
            const SizedBox(height: 12),
            const Text("Products:", style: TextStyle(fontWeight: FontWeight.bold)),
            ...todo.products.map((product) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "- ${product.description} (Qty: ${product.quantity}, \$${product.value.toStringAsFixed(2)})",
                style: const TextStyle(fontSize: 12),
              ),
            )).toList(),

            // Action buttons
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  onPressed: () => controller.deleteTodo(todo.id!),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () =>controller.deleteTodo(todo.id!),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteTodo(todo.id!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(label, style: const TextStyle(color: Colors.grey)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
  void _showAddEditTodoDialog(BuildContext context, {bool isEditing = false}) {
    if (!isEditing) {
      controller.clearForm();
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditing ? 'Edit Order' : 'Place Order',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo, width: 2),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (isEditing) {
                        controller.updateTodo();
                      } else {
                        controller.addTodo();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white
                    ),
                    child: Text(isEditing ? 'Update' : 'Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Todo todo) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteTodo(todo.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
