import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simpl/data/models/order_model.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';
import 'package:simpl/routes/app_pages.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.orders.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.indigo),
          );
        }

        if (controller.orders.isEmpty) {
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
                  onPressed: () {
                    // controller.clearForm();
                    Get.toNamed(Routes.CREATE_ORDER);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return _buildOrderItem(context, order);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // controller.clearForm();
          Get.toNamed(Routes.CREATE_ORDER);
        },
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Order order) {
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
                  "Order #${order.warehouseNumber}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.indigo,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: order.isShipped
                        ? Colors.green[100]
                        : Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.isShipped ? "Shipped" : "Not Shipped",
                    style: TextStyle(
                      color: order.isShipped
                          ? Colors.green[800]
                          : Colors.orange[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Order details
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(2),
              },
              children: [
                _buildTableRow("Service:", order.shippingServiceName),
                // _buildTableRow("Carrier:", order.carrier ?? "Unknown"),
                _buildTableRow(
                  "Order Date:",
                  DateFormat('MMM dd, yyyy').format(order.orderDate),
                ),
                _buildTableRow("Weight:", "${order.weight} kg"),
                _buildTableRow(
                  "Order Value:",
                  "\$${order.orderValue.toStringAsFixed(2)}",
                ),
                // _buildTableRow("Shipping Cost:", "\$${order.shippingValue.toStringAsFixed(2)}"),
                _buildTableRow("Total:", "\$${order.total.toStringAsFixed(2)}"),
                _buildTableRow(
                  "Recipient:",
                  "${order.recipient.firstName} ${order.recipient.lastName}",
                ),
                _buildTableRow("Country:", order.recipient.countryIsoCode),
                _buildTableRow("Address:", order.recipient.address),
              ],
            ),

            // Products section
            const SizedBox(height: 12),
            const Text(
              "Products:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...order.products.map(
              (product) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "- ${product.description} (Qty: ${product.quantity}, \$${product.value.toStringAsFixed(2)})",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),

            // Action buttons
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // IconButton(
                //   icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                //   onPressed: () => controller.viewOrder(order.id!),
                // ),
                // IconButton(
                //   icon: const Icon(Icons.edit, color: Colors.blue),
                //   onPressed: () =>controller.editOrder(order.id!),
                // ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(context, order),
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
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, Order order) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Order'),
        content: const Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteOrder(order.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
