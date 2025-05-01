
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';

class ParcelDetailsForm extends GetView<OrderController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.parcelDetailsFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Shipping Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Service ID Dropdown
            DropdownButtonFormField<int>(
              value: controller.selectedServiceId.value,
              onChanged: (value) => controller.selectedServiceId.value = value!,
              decoration: const InputDecoration(
                labelText: 'Service',
                border: OutlineInputBorder(),
              ),
              items: controller.services
                  .map((service) => DropdownMenuItem(
                value: service.id,
                child: Text(service.name),
              ))
                  .toList(),
              validator: (value) =>
              value == null ? 'Please select a service' : null,
            ),
            const SizedBox(height: 12),

            // Tax Modality Dropdown
            DropdownButtonFormField<String>(
              value: controller.taxModality.value,
              onChanged: (value) => controller.taxModality.value = value!,
              decoration: const InputDecoration(
                labelText: 'Tax Modality',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'DDU', child: Text('DDU')),
                DropdownMenuItem(value: 'DDP', child: Text('DDP')),
              ],
              validator: (value) =>
              value == null ? 'Please select tax modality' : null,
            ),
            const SizedBox(height: 16),

            const Text('Products', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Obx(() {
              if (controller.products.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('No products added yet', textAlign: TextAlign.center),
                );
              }
              return ListView.builder(
                itemCount: controller.products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final product = controller.products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButtonFormField<int>(
                            value: product.selectedShCode.value,
                            onChanged: (value) => product.selectedShCode.value = value!,
                            decoration: const InputDecoration(
                              labelText: 'Sh Code',
                              border: OutlineInputBorder(),
                            ),
                            items: product.shCodes
                                .map((shCode) => DropdownMenuItem(
                              value: shCode.code,
                              child: Text(shCode.description),
                            ))
                                .toList(),
                            validator: (value) =>
                            value == null ? 'Please select sh code' : null,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: product.descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            validator: controller.validateRequired,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: product.quantityController,
                                  decoration: const InputDecoration(
                                    labelText: 'Quantity',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: controller.validateNumber,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: product.valueController,
                                  decoration: const InputDecoration(
                                    labelText: 'Value (\$)',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: controller.validateNumber,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Obx(() => CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Battery"),
                                value: product.isBattery.value,
                                onChanged: (val) =>
                                product.isBattery.value = val!,
                              )),
                              Obx(() => CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Perfume"),
                                value: product.isPerfume.value,
                                onChanged: (val) =>
                                product.isPerfume.value = val!,
                              )),
                              Obx(() => CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Flammable"),
                                value: product.isFlameable.value,
                                onChanged: (val) =>
                                product.isFlameable.value = val!,
                              )),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => controller.removeProduct(index),
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text('Remove',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.addProduct();
                  // Scroll to bottom when new product is added
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Scrollable.ensureVisible(
                      context,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}