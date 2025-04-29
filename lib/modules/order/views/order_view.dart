import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/data/models/order_model.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';
import 'package:intl/intl.dart';
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
                  onPressed: () => _showAddEditOrderDialog(context),
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
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return _buildOrderItem(context, order);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditOrderDialog(context),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: order.isShipped ? Colors.green[100] : Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.isShipped ? "Shipped" : "Not Shipped",
                    style: TextStyle(
                      color: order.isShipped ? Colors.green[800] : Colors.orange[800],
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
                _buildTableRow("Service:", order.shippingServiceName),
                // _buildTableRow("Carrier:", order.carrier ?? "Unknown"),
                _buildTableRow("Order Date:", DateFormat('MMM dd, yyyy').format(order.orderDate)),
                _buildTableRow("Weight:", "${order.weight} kg"),
                _buildTableRow("Order Value:", "\$${order.orderValue.toStringAsFixed(2)}"),
                // _buildTableRow("Shipping Cost:", "\$${order.shippingValue.toStringAsFixed(2)}"),
                _buildTableRow("Total:", "\$${order.total.toStringAsFixed(2)}"),
                _buildTableRow("Recipient:", "${order.recipient.firstName} ${order.recipient.lastName}"),
                _buildTableRow("Country:", order.recipient.countryIsoCode),
                _buildTableRow("Address:", order.recipient.address),
              ],
            ),

            // Products section
            const SizedBox(height: 12),
            const Text("Products:", style: TextStyle(fontWeight: FontWeight.bold)),
            ...order.products.map((product) => Padding(
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
                  onPressed: () => _showDeleteConfirmation(context,order),
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
  void _showAddEditOrderDialog(BuildContext context, {bool isEditing = false}) {
    // Initialize controllers with default values if not editing
    if (!isEditing) {
      controller.clearForm();
      // Set default values
      controller.titleController.text = 'title';
      controller.descriptionController.text = 'description';
      controller.weightController.text = '1.0';
      controller.trackingIdController.text = 'mobile-';
      controller.customerReferenceController.text = 'mobile-';
      controller.recipientPhoneController.text = '+5511937293951';
      controller.recipientEmailController.text = 'reciepint@gami.com';
      controller.recipientNameController.text = 'reciepint';
      controller.senderNameController.text = 'sender';
      controller.senderEmailController.text = 'snder@gami.com';
      controller.shipmentValueController.text = '10.0';
      controller.lengthController.text = '30.0';
      controller.widthController.text = '20.0';
      controller.heightController.text = '10.0';
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditing ? 'Edit Order' : 'Create Order',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Basic Information Section
              const Text('Basic Information', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  labelText: 'Order Title*',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo, width: 2),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.trackingIdController,
                decoration: const InputDecoration(
                  labelText: 'Tracking ID*',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 54105_001234',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.customerReferenceController,
                decoration: const InputDecoration(
                  labelText: 'Customer Reference',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 54105_001343',
                ),
              ),

              // Parcel Details Section
              const SizedBox(height: 16),
              const Text('Parcel Details', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.weightController,
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)*',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller.shipmentValueController,
                      decoration: const InputDecoration(
                        labelText: 'Value (\$)*',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Dimensions (cm)', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.lengthController,
                      decoration: const InputDecoration(
                        labelText: 'Length',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller.widthController,
                      decoration: const InputDecoration(
                        labelText: 'Width',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller.heightController,
                      decoration: const InputDecoration(
                        labelText: 'Height',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              // Sender Information Section
              const SizedBox(height: 16),
              const Text('Sender Information', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.senderNameController,
                decoration: const InputDecoration(
                  labelText: 'Name*',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Thomaz Marques',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.senderEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email*',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., contato@babylicio.us',
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              // Recipient Information Section
              const SizedBox(height: 16),
              const Text('Recipient Information', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.recipientNameController,
                decoration: const InputDecoration(
                  labelText: 'Name*',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Alex Hoyos',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.recipientEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., test@hd.com',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.recipientPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., +5511937293951',
                ),
                keyboardType: TextInputType.phone,
              ),

              // Action Buttons
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
                        // controller.updateOrder();
                      } else {
                        controller.createOrder();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(isEditing ? 'Update Order' : 'Create Order'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showDeleteConfirmation(BuildContext context, Order order) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete order'),
        content: const Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
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
