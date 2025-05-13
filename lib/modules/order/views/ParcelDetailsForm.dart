import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';
import 'package:home_delivery_br/modules/order/controllers/validators/order_validators.dart';

class ParcelDetailsForm extends GetView<OrderCreateController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: controller.parcelDetailsFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Shipping Details', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
          Obx(() {
            final errorText = controller.fieldErrors["parcel.service_id"];
            return _buildCard(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DropdownButtonFormField<int>(
                      isExpanded: true, // <-- Important!
                      value: controller.parcelController.selectedServiceId.value,
                      onChanged: (value) {
                        controller.parcelController.selectedServiceId.value = value!;
                        controller.clearFieldError("parcel.service_id");
                      },
                      decoration: InputDecoration(
                        labelText: 'Service',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        errorText: errorText,
                      ),
                      items: controller.parcelController.services
                          .map((service) => DropdownMenuItem(
                        value: service.id,
                        child: Text(
                          service.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                          .toList(),
                      validator: (value) => value == null ? 'Please select a service' : null,
                    ),
                  );
                },
              ),
            );
          }),
            const SizedBox(height: 16),

            // Tax Modality Dropdown
            Obx(() {
              final errorText = controller.getFieldError('parcel.tax_modality');
              return _buildCard(
                child: DropdownButtonFormField<String>(
                  value: controller.parcelController.taxModality.value,
                  onChanged: (value) {
                    controller.parcelController.taxModality.value = value!;
                    controller.clearFieldError("parcel.tax_modality");
                  },
                  decoration: InputDecoration(
                    labelText: 'Tax Modality',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    errorText: errorText,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'DDU', child: Text('DDU')),
                    DropdownMenuItem(value: 'DDP', child: Text('DDP')),
                  ],
                  validator: (value) => value == null ? 'Please select tax modality' : null,
                ),
              );
            }),
            const SizedBox(height: 24),

            // Products Section
            Text('Products', style: theme.textTheme.titleLarge),
            const Divider(),
            const SizedBox(height: 12),

            Obx(() {
              if (controller.productController.products.isEmpty) {
                final productsError = controller.getFieldError('products');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    productsError?.isNotEmpty == true
                        ? productsError!
                        : 'No products added yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: productsError != null ? Colors.red : Colors.grey[700],
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.productController.products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final product = controller.productController.products[index];
                  return _buildProductCard(product, index);
                },
              );
            }),

            // Add Product Button
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                controller.productController.addProduct();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add),
              label: const Text("Add Product"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(product, int index) {
    final shCodeError = controller.getFieldError('products.$index.sh_code');
    final descriptionError = controller.getFieldError('products.$index.description');
    final valueError = controller.getFieldError('products.$index.value');
    final quantityError = controller.getFieldError('products.$index.quantity');

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                  labelText: 'SH Code',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  errorText: shCodeError,
                ),
                isExpanded: true,
                items: shCodes.isEmpty
                    ? [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Loading shCodes...'),
                  )
                ]
                    : shCodes
                    .map((shCode) => DropdownMenuItem(
                  value: shCode.code,
                  child: Text(
                    shCode.description,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
                    .toList(),
              );
            }),
            const SizedBox(height: 12),
            TextFormField(
              controller: product.descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                errorText: descriptionError,
              ),
              onChanged: (_) => controller.clearFieldError('products.$index.description'),
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: product.quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      errorText: quantityError,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => controller.clearFieldError('products.$index.quantity'),
                    validator: OrderValidators.validateNumber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: product.valueController,
                    decoration: InputDecoration(
                      labelText: 'Value (\$)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      errorText: valueError,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => controller.clearFieldError('products.$index.value'),
                    validator: OrderValidators.validateNumber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                Obx(() => FilterChip(
                  label: const Text("Battery"),
                  selected: product.isBattery.value,
                  onSelected: (val) => product.isBattery.value = val,
                )),
                Obx(() => FilterChip(
                  label: const Text("Perfume"),
                  selected: product.isPerfume.value,
                  onSelected: (val) => product.isPerfume.value = val,
                )),
                Obx(() => FilterChip(
                  label: const Text("Flammable"),
                  selected: product.isFlameable.value,
                  onSelected: (val) => product.isFlameable.value = val,
                )),
              ],
            ),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => controller.productController.removeProduct(index),
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                label: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}