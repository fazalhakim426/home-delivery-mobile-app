import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_create_controller.dart';
import 'package:simpl/modules/order/controllers/validators/order_validators.dart';

class ParcelDetailsForm extends GetView<OrderCreateController> {
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

            // Service Dropdown
            Obx(() {
              final errorText = controller.fieldErrors["parcel.service_id"];
              return DropdownButtonFormField<int>(
                value: controller.parcelController.selectedServiceId.value,
                onChanged: (value) {
                  controller.parcelController.selectedServiceId.value = value!;
                  controller.clearFieldError("parcel.service_id");
                },
                decoration: InputDecoration(
                  labelText: 'Service',
                  border: const OutlineInputBorder(),
                  errorText: errorText,
                ),
                items: controller.parcelController.services
                    .map((service) => DropdownMenuItem(
                  value: service.id,
                  child: Text(service.name),
                ))
                    .toList(),
                validator: (value) => value == null ? 'Please select a service' : null,
              );
            }),
            const SizedBox(height: 12),

            // Tax Modality Dropdown
            Obx(() {
              final errorText = controller.getFieldError('parcel.tax_modality');
              return DropdownButtonFormField<String>(
                value: controller.parcelController.taxModality.value,
                onChanged: (value) {
                  controller.parcelController.taxModality.value = value!;
                  controller.clearFieldError("parcel.tax_modality");
                },
                decoration: InputDecoration(
                  labelText: 'Tax Modality',
                  border: OutlineInputBorder(),
                  errorText: errorText,
                ),
                items: const [
                  DropdownMenuItem(value: 'DDU', child: Text('DDU')),
                  DropdownMenuItem(value: 'DDP', child: Text('DDP')),
                ],
                validator: (value) => value == null ? 'Please select tax modality' : null,
              );
            }),
            const SizedBox(height: 16),

            // Products Section
            const Text('Products', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Obx(() {
              if (controller.productController.products.isEmpty) {
                final productsError = controller.getFieldError('products');
                if (productsError != null && productsError.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      productsError,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'No products added yet',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              }
              return ListView.builder(
                itemCount: controller.productController.products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final product = controller.productController.products[index];
                  final shCodeError = controller.getFieldError('products.$index.sh_code');
                  final descriptionError = controller.getFieldError('products.$index.description');
                  final valueError = controller.getFieldError('products.$index.value');
                  final quantityError = controller.getFieldError('products.$index.quantity');

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            final shCodes = controller.parcelController.shCodes;
                            return DropdownButtonFormField<int>(
                              value: product.selectedShCode.value,
                              onChanged: (value) {
                                product.selectedShCode.value = value!;
                                controller.clearFieldError('products.$index.sh_code');
                              },
                              decoration: InputDecoration(
                                labelText: 'Sh Code',
                                border: const OutlineInputBorder(),
                                errorText: shCodeError,
                                isDense: true,
                              ),
                              isExpanded: true,
                              items: shCodes.isEmpty
                                  ? [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('Loading shCodes...'),
                                )
                              ]
                                  : shCodes.map((shCode) => DropdownMenuItem(
                                value: shCode.code,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300, // Adjust based on your needs
                                  ),
                                  child: Text(
                                    shCode.description,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              )).toList(),
                              validator: (value) => value == null ? 'Please select sh code' : null,
                            );
                          }),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: product.descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                              isDense: true,
                              errorText: descriptionError,
                            ),
                            onChanged: (value) {
                              controller.clearFieldError('products.$index.description');
                            },
                            validator: OrderValidators.validateRequired,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: product.quantityController,
                                  decoration: InputDecoration(
                                    labelText: 'Quantity',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    errorText: quantityError,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    controller.clearFieldError('products.$index.quantity');
                                  },
                                  validator: OrderValidators.validateNumber,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: product.valueController,
                                  decoration: InputDecoration(
                                    labelText: 'Value (\$)',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    errorText: valueError,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    controller.clearFieldError('products.$index.value');
                                  },
                                  validator: OrderValidators.validateNumber,
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
                                onChanged: (val) => product.isBattery.value = val!,
                              )),
                              Obx(() => CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Perfume"),
                                value: product.isPerfume.value,
                                onChanged: (val) => product.isPerfume.value = val!,
                              )),
                              Obx(() => CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text("Flammable"),
                                value: product.isFlameable.value,
                                onChanged: (val) => product.isFlameable.value = val!,
                              )),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => controller.productController.removeProduct(index),
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

            // Add Product Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.productController.addProduct();
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