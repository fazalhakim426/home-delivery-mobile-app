import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/widgets/app_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:home_delivery_br/app/app_colors.dart';
import 'package:home_delivery_br/data/models/order_model.dart';
import 'package:home_delivery_br/modules/order/controllers/order_view_controller.dart';
import 'package:home_delivery_br/routes/app_pages.dart';

import 'dart:async';
class OrderView extends GetView<OrderViewController> {
  const OrderView({super.key});
  Widget build(BuildContext context) {
    return AppScaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchOrders();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           // Header with improved styling
            //           Container(
            //             padding: const EdgeInsets.symmetric(vertical: 8),
            //             child: Text(
            //               'Your Recent Orders',
            //               style: TextStyle(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.grey[800],
            //                 letterSpacing: 0.3,
            //               ),
            //             ),
            //           ),
            //
            //           // Subtitle with better spacing
            //           Padding(
            //             padding: const EdgeInsets.only(bottom: 16),
            //             child: Text(
            //               'Below are your most recent activities',
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 color: Colors.grey[600],
            //                 fontStyle: FontStyle.italic,
            //               ),
            //             ),
            //           ),
            //
            //           // Enhanced search field
            //           TextField(
            //             decoration: InputDecoration(
            //               hintText: 'Search by order ID, customer or date...',
            //               hintStyle: TextStyle(
            //                 color: Colors.grey[500],
            //                 fontSize: 14,
            //               ),
            //               prefixIcon: Icon(
            //                 Icons.search,
            //                 color: Colors.grey[600],
            //               ),
            //               filled: true,
            //               fillColor: Colors.grey[50],
            //               border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(12),
            //                 borderSide: BorderSide(
            //                   color: Colors.grey[300]!,
            //                   width: 1.5,
            //                 ),
            //               ),
            //               enabledBorder: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(12),
            //                 borderSide: BorderSide(
            //                   color: Colors.grey[300]!,
            //                   width: 1.5,
            //                 ),
            //               ),
            //               focusedBorder: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(12),
            //                 borderSide: BorderSide(
            //                   color: AppColors.primary,
            //                   width: 1.5,
            //                 ),
            //               ),
            //               contentPadding: const EdgeInsets.symmetric(
            //                 vertical: 16,
            //                 horizontal: 16,
            //               ),
            //             ),
            //             style: TextStyle(
            //               fontSize: 14,
            //               color: Colors.grey[800],
            //               fontWeight: FontWeight.w500,
            //             ),
            //             onChanged: (value) {
            //               debounce(
            //                     () => controller.searchOrders(value),
            //                 const Duration(milliseconds: 500),
            //               );
            //             },
            //           ),
            //         ],
            //       ),
            //
            //       const SizedBox(height: 16),
            //       // Date Filter Row
            //       Row(
            //         children: [
            //           Expanded(
            //             child: InkWell(
            //               borderRadius: BorderRadius.circular(12),
            //               onTap: () async {
            //                 final selectedDate = await showDatePicker(
            //                   context: context,
            //                   initialDate: controller.startDate.value,
            //                   firstDate: DateTime(2000),
            //                   lastDate: DateTime.now(),
            //                 );
            //                 if (selectedDate != null) {
            //                   controller.filterByDate(
            //                     selectedDate,
            //                     controller.endDate.value,
            //                   );
            //                 }
            //               },
            //               child: Container(
            //                 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            //                 decoration: BoxDecoration(
            //                   color: Colors.grey[50],
            //                   border: Border.all(
            //                     color: Colors.grey[300]!,
            //                     width: 1.5,
            //                   ),
            //                   borderRadius: BorderRadius.circular(12),
            //                   boxShadow: [
            //                     BoxShadow(
            //                       color: Colors.black.withOpacity(0.05),
            //                       blurRadius: 4,
            //                       offset: const Offset(0, 2),
            //                     ),
            //                   ],
            //                 ),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       DateFormat('MMM dd, yyyy').format(controller.startDate.value),
            //                       style: TextStyle(
            //                         fontSize: 14,
            //                         fontWeight: FontWeight.w600,
            //                         color: Colors.grey[800],
            //                       ),
            //                     ),
            //                     Icon(Icons.calendar_month,
            //                       size: 20,
            //                       color: AppColors.primary,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 12),
            //             child: Text(
            //               'to',
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.grey[600],
            //               ),
            //             ),
            //           ),
            //           Expanded(
            //             child: InkWell(
            //               borderRadius: BorderRadius.circular(12),
            //               onTap: () async {
            //                 final selectedDate = await showDatePicker(
            //                   context: context,
            //                   initialDate: controller.endDate.value,
            //                   firstDate: DateTime(2000),
            //                   lastDate: DateTime.now(),
            //                 );
            //                 if (selectedDate != null) {
            //                   controller.filterByDate(
            //                     controller.startDate.value,
            //                     selectedDate,
            //                   );
            //                 }
            //               },
            //               child: Container(
            //                 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            //                 decoration: BoxDecoration(
            //                   color: Colors.grey[50],
            //                   border: Border.all(
            //                     color: Colors.grey[300]!,
            //                     width: 1.5,
            //                   ),
            //                   borderRadius: BorderRadius.circular(12),
            //                   boxShadow: [
            //                     BoxShadow(
            //                       color: Colors.black.withOpacity(0.05),
            //                       blurRadius: 4,
            //                       offset: const Offset(0, 2),
            //                     ),
            //                   ],
            //                 ),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       DateFormat('MMM dd, yyyy').format(controller.endDate.value),
            //                       style: TextStyle(
            //                         fontSize: 14,
            //                         fontWeight: FontWeight.w600,
            //                         color: Colors.grey[800],
            //                       ),
            //                     ),
            //                     Icon(Icons.calendar_month,
            //                       size: 20,
            //                       color: AppColors.primary,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //
            //     ],
            //   ),
            // ),


            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Orders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  IconButton(
                    icon: Obx(() => Icon(
                      controller.isFilterVisible.value ? Icons.filter_alt : Icons.filter_alt_outlined,
                      color: AppColors.primary,
                      size: 28,
                    )),
                    onPressed: controller.toggleFilterVisibility,
                  ),
                ],
              ),
            ),

            // Collapsible filter section
            Obx(() => AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: controller.isFilterVisible.value
                  ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search field
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by order ID, customer or date...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        // prefixIcon: Icon(
                        //   Icons.search,
                        //   color: Colors.grey[600],
                        // ),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                      onChanged: (value) {
                        debounce(
                              () => controller.searchOrders(value),
                          const Duration(milliseconds: 500),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Date filter row
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: controller.startDate.value,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                controller.filterByDate(
                                  selectedDate,
                                  controller.endDate.value,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(controller.startDate.value),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Icon(Icons.calendar_month,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'to',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: controller.endDate.value,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                controller.filterByDate(
                                  controller.startDate.value,
                                  selectedDate,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(controller.endDate.value),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Icon(Icons.calendar_month,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            )),

            // Order List Section
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.orders.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.list, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          controller.searchQuery.value.isEmpty
                              ? 'No orders found in selected period'
                              : 'No orders match your search',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Place New Order',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => Get.toNamed(Routes.CREATE_ORDER),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
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

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                        controller.hasMore &&
                        !controller.isLoadMore.value) {
                      controller.fetchOrders(loadMore: true);
                    }
                    return false;
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 80), // Space for FABs
                    itemCount: controller.orders.length + (controller.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= controller.orders.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final order = controller.orders[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: _buildOrderItem(order),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
     );
  }

  void debounce(VoidCallback callback, Duration duration) {
    Timer? timer;
    if (timer != null) {
      timer.cancel();
    }
    timer = Timer(duration, callback);
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
              _buildDetailRow("Weight:", "${order.weight} ${order.measurementUnit?.split('/').first ?? 'kg.'}"),
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

  // Widget _buildDetailRow(String label, dynamic value, {TextStyle? textStyle}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 120,
  //           child: Text(
  //             label,
  //             style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
  //           ),
  //         ),
  //         Expanded(
  //           child: Text(
  //             value.toString(),
  //             style: textStyle ?? const TextStyle(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDetailRow(String label, dynamic value, {TextStyle? textStyle}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50], // Light background
        borderRadius: BorderRadius.circular(8), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                label.toUpperCase(), // Uppercase for labels
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  value.toString(),
                  style: textStyle ?? TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ],
        ),
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