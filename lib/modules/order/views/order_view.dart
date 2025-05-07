import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simpl/app/app_colors.dart';
import 'package:simpl/data/models/order_model.dart';
import 'package:simpl/modules/auth/controllers/auth_controller.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';
import 'package:simpl/routes/app_pages.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final authController = Get.find<AuthController>();
              authController.logout();
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchOrders();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Below are your most recent orders',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.orders.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
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
                          'No orders yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Place New Order',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => {
                            Get.toNamed(Routes.CREATE_ORDER)
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () => controller.fetchOrders(),
                          child: const Text('Refresh Orders'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    return _buildOrderItem(order);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'tracking',
            onPressed: () => Get.toNamed(Routes.TRACKINGS),
            backgroundColor: AppColors.primary,
            mini: true,
            child: const Icon(Icons.local_shipping, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'create',
            onPressed: () => Get.toNamed(Routes.CREATE_ORDER),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
  Widget _buildOrderItem(Order order) {
    return InkWell(
      onTap: () => _showOrderDetails(order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${order.warehouseNumber}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${order.total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEE. MMMM d').format(order.orderDate),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${order.weight} kg",
                  style: const TextStyle(color: Colors.grey),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: order.status=='Shipped' ? Colors.green[50] : Colors.orange[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: order.status=='Shipped'  ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(Order order) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order #${order.warehouseNumber ?? order.id}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "\$${order.total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMMM d, yyyy - hh:mm a').format(order.orderDate),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: order.status=='Shipped' ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(order.status,
                  style: TextStyle(
                    color: order.status == 'Shipped'? Colors.green :
                    order.status == 'Cancelled'? Colors.red :
                    order.status=='Refunded' ? Colors.purple : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),

              // Order Summary Section
              const Text(
                "Order Summary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildDetailRow("Service:", order.shippingServiceName),
              _buildDetailRow("Carrier:", order.carrier ?? "Not specified"),
              _buildDetailRow("Tracking ID:", order.trackingCode ?? "Not available"),
              _buildDetailRow("Reference:", order.customerReference ?? "Not provided"),
              _buildDetailRow("Merchant:", order.merchant ?? "Not specified"),
              const SizedBox(height: 16),

              // Dimensions Section
              const Text(
                "Package Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildDetailRow("Weight:", "${order.weight} ${order.measurementUnit?.split('/').first ?? 'kg'}"),
              if (order.volumetricWeight != null)
                _buildDetailRow("Vol. Weight:", "${order.volumetricWeight!.toStringAsFixed(2)} kg"),
              _buildDetailRow("Dimensions:", "${order.length} x ${order.width} x ${order.height} cm"),
              _buildDetailRow("Items:", "${order.products.length} products"),
              const SizedBox(height: 16),

              // Financial Section
              const Text(
                "Financial Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildDetailRow("Order Value:", "\$${order.orderValue.toStringAsFixed(2)}"),
              _buildDetailRow("Shipping:", "\$${order.shippingValue?.toStringAsFixed(2) ?? '0.00'}"),
              if (order.discount > 0)
                _buildDetailRow("Discount:", "-\$${order.discount.toStringAsFixed(2)}"),
              _buildDetailRow("Tax & Duty:", "\$${order.taxAndDuty.toStringAsFixed(2)}"),
              _buildDetailRow("Fee for Tax:", "\$${order.feeForTaxAndDuty.toStringAsFixed(2)}"),
              const Divider(),
              _buildDetailRow("Gross Total:", "\$${order.grossTotal.toStringAsFixed(2)}",
                  textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700])),
              const SizedBox(height: 16),

              // Recipient Section
              const Text(
                "Recipient Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildDetailRow("Name:", "${order.recipient.firstName} ${order.recipient.lastName}"),
              _buildDetailRow("Email:", order.recipient.email),
              _buildDetailRow("Phone:", order.recipient.phone),
              _buildDetailRow("Address:",
                  "${order.recipient.address}, ${order.recipient.address2}\n"
                      "${order.recipient.city}, ${order.recipient.stateIsoCode}\n"
                      "${order.recipient.zipcode}, ${order.recipient.countryIsoCode}"),
              _buildDetailRow("Tax ID:", order.recipient.taxId ?? "Not provided"),
              const SizedBox(height: 16),

              // Sender Section
              const Text(
                "Sender Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildDetailRow("Name:", "${order.sender.firstName} ${order.sender.lastName}"),
              _buildDetailRow("Email:", order.sender.email),
              _buildDetailRow("Tax ID:", order.sender.taxId ?? "Not provided"),
              const SizedBox(height: 16),

              // Products Section
              const Text(
                "Products",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...order.products.map((product) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Description:", product.description),
                  _buildDetailRow("Quantity:", product.quantity),
                  _buildDetailRow("Value:", "\$${product.value}"),
                  _buildDetailRow("HS Code:", product.shCode),
                  if (product.isBattery == "1" || product.isPerfume == "1")
                    _buildDetailRow("Special:",
                        "${product.isBattery == "1" ? 'Contains Battery' : ''}"
                            "${product.isPerfume == "1" ? 'Contains Perfume' : ''}"),
                  const Divider(),
                ],
              )),
              const SizedBox(height: 16),
              // Action Buttons
              Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton.icon(
                  //   icon: const Icon(Icons.edit, size: 18),
                  //   label: const Text("Edit"),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue[50],
                  //     foregroundColor: Colors.blue,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     Get.back();
                  //     Get.toNamed(Routes.CREATE_ORDER, arguments: order);
                  //   },
                  // ),

                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete, size: 22),
                    label: const Text("Delete order"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _confirmDelete(order),
                  ),


                  if (order.trackingCode != null && order.trackingCode!.isNotEmpty)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.track_changes, size: 18),
                      label: const Text("Track"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[50],
                        foregroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        Get.toNamed(Routes.TRACKINGS, arguments: order.trackingCode);
                      },
                    ),

                ],

              ),

              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

// Updated helper method to support custom text styling
  Widget _buildDetailRow(String label, dynamic value, {TextStyle? textStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: textStyle ?? const TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
  void _confirmDelete(Order order) {
    Get.back(); // Close the bottom sheet first
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Order'),
        content: const Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteOrder(order.id!);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}