import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/app/app_styles.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';
import 'package:home_delivery_br/modules/order/controllers/validators/order_validators.dart';

class ParcelDetailsForm extends GetView<OrderCreateController> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: controller.parcelDetailsFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Shipping Details Header
            Text(
              'Shipping Details',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
// Combined Service and Tax Modality in one card
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Service Dropdown
                  Obx(() {
                    final errorText = controller.fieldErrors["parcel.service_id"];
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(minWidth: constraints.maxWidth),
                          child: DropdownButtonFormField<int>(
                            isExpanded: true,
                            value: controller.parcelController.selectedServiceId.value,
                            onChanged: (value) {
                              controller.parcelController.selectedServiceId.value = value!;
                              controller.clearFieldError("parcel.service_id");
                            },
                            decoration: InputDecoration(
                              labelText: 'Shipping Service',
                              labelStyle: AppStyles.inputLabelStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: colorScheme.outline),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: colorScheme.outline),
                              ),
                              errorText: errorText,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            style: AppStyles.inputTextStyle,
                            items: controller.parcelController.services
                                .map((service) => DropdownMenuItem(
                              value: service.id,
                              child: Text(
                                service.name,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.dropdownItemStyle,
                              ),
                            ))
                                .toList(),
                            validator: (value) =>
                            value == null ? 'Please select a service' : null,
                          ),
                        );
                      },
                    );
                  }),

                  const SizedBox(height: 40),

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
                        labelText: 'Tax Responsibility',
                        labelStyle: AppStyles.inputLabelStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.outline),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        errorText: errorText,
                      ),
                      style: AppStyles.inputTextStyle,
                      items: const [
                        DropdownMenuItem(
                          value: 'DDU',
                          child: Text('Delivered Duty Unpaid (DDU)',
                              style: AppStyles.dropdownItemStyle),
                        ),
                        DropdownMenuItem(
                          value: 'DDP',
                          child: Text('Delivered Duty Paid (DDP)',
                              style: AppStyles.dropdownItemStyle),
                        ),
                      ],
                      validator: (value) =>
                      value == null ? 'Please select tax modality' : null,
                    );
                  }),
                ],
              ),
            ),
            // Service Dropdown
            // Obx(() {
            //   final errorText = controller.fieldErrors["parcel.service_id"];
            //   return _buildCard(
            //     child: LayoutBuilder(
            //       builder: (context, constraints) {
            //         return ConstrainedBox(
            //           constraints: BoxConstraints(minWidth: constraints.maxWidth),
            //           child: DropdownButtonFormField<int>(
            //             isExpanded: true,
            //             value: controller.parcelController.selectedServiceId.value,
            //             onChanged: (value) {
            //               controller.parcelController.selectedServiceId.value = value!;
            //               controller.clearFieldError("parcel.service_id");
            //             },
            //             decoration: InputDecoration(
            //               labelText: 'Service',
            //               labelStyle: AppStyles.inputLabelStyle,
            //               border: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(12),
            //                 borderSide: BorderSide(color: colorScheme.outline),
            //               ),
            //               enabledBorder: OutlineInputBorder(
            //                 borderRadius: BorderRadius.circular(12),
            //                 borderSide: BorderSide(color: colorScheme.outline),
            //               ),
            //               errorText: errorText,
            //               contentPadding: const EdgeInsets.symmetric(
            //                 horizontal: 16,
            //                 vertical: 14,
            //               ),
            //             ),
            //             style: AppStyles.inputTextStyle,
            //             items: controller.parcelController.services
            //                 .map((service) => DropdownMenuItem(
            //               value: service.id,
            //               child: Text(
            //                 service.name,
            //                 overflow: TextOverflow.ellipsis,
            //                 style: AppStyles.dropdownItemStyle,
            //               ),
            //             ))
            //                 .toList(),
            //             validator: (value) =>
            //             value == null ? 'Please select a service' : null,
            //           ),
            //         );
            //       },
            //     ),
            //   );
            // }),
            // const SizedBox(height: 20),
            //
            // // Tax Modality Dropdown
            // Obx(() {
            //   final errorText = controller.getFieldError('parcel.tax_modality');
            //   return _buildCard(
            //     child: DropdownButtonFormField<String>(
            //       value: controller.parcelController.taxModality.value,
            //       onChanged: (value) {
            //         controller.parcelController.taxModality.value = value!;
            //         controller.clearFieldError("parcel.tax_modality");
            //       },
            //       decoration: InputDecoration(
            //         labelText: 'Tax Modality',
            //         labelStyle: AppStyles.inputLabelStyle,
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(12),
            //           borderSide: BorderSide(color: colorScheme.outline),
            //         ),
            //         contentPadding: const EdgeInsets.symmetric(
            //           horizontal: 16,
            //           vertical: 14,
            //         ),
            //         errorText: errorText,
            //       ),
            //       style: AppStyles.inputTextStyle,
            //       items: const [
            //         DropdownMenuItem(
            //           value: 'DDU',
            //           child: Text('DDU', style: AppStyles.dropdownItemStyle),
            //         ),
            //         DropdownMenuItem(
            //           value: 'DDP',
            //           child: Text('DDP', style: AppStyles.dropdownItemStyle),
            //         ),
            //       ],
            //       validator: (value) =>
            //       value == null ? 'Please select tax modality' : null,
            //     ),
            //   );
            // }),
            // const SizedBox(height: 32),

            // Products Section
            Text(
              'Products',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const Divider(height: 24, thickness: 1),
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
                    style: productsError != null
                        ? AppStyles.errorTextStyle
                        : AppStyles.hintTextStyle,
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => controller.productController.addProduct(),
              style: AppStyles.primaryButtonStyle,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text("Add Product", style: AppStyles.buttonTextStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(product, int index) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(Get.context!).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SH Code Dropdown
            Obx(() {
              final shCodes = controller.parcelController.shCodes;
              final errorText = controller.getFieldError('products.$index.sh_code');
              return DropdownButtonFormField<int>(
                value: product.selectedShCode.value,
                onChanged: (value) {
                  product.selectedShCode.value = value!;
                  controller.clearFieldError('products.$index.sh_code');
                },
                decoration: InputDecoration(
                  labelText: 'SH Code',
                  labelStyle: AppStyles.inputLabelStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  errorText: errorText,
                ),
                style: AppStyles.inputTextStyle,
                isExpanded: true,
                items: shCodes.isEmpty
                    ? [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Loading shCodes...',
                        style: AppStyles.dropdownItemStyle),
                  )
                ]
                    : shCodes
                    .map((shCode) => DropdownMenuItem(
                  value: shCode.code,
                  child: Text(
                    shCode.description,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.dropdownItemStyle,
                  ),
                ))
                    .toList(),
              );
            }),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: product.descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: AppStyles.inputLabelStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                errorText: controller.getFieldError('products.$index.description'),
              ),
              style: AppStyles.inputTextStyle,
              onChanged: (_) =>
                  controller.clearFieldError('products.$index.description'),
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 16),

            // Quantity and Value Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: product.quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      labelStyle: AppStyles.inputLabelStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      errorText: controller.getFieldError('products.$index.quantity'),
                    ),
                    style: AppStyles.inputTextStyle,
                    keyboardType: TextInputType.number,
                    onChanged: (_) =>
                        controller.clearFieldError('products.$index.quantity'),
                    validator: OrderValidators.validateNumber,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: product.valueController,
                    decoration: InputDecoration(
                      labelText: 'Value (\$)',
                      labelStyle: AppStyles.inputLabelStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      errorText: controller.getFieldError('products.$index.value'),
                    ),
                    style: AppStyles.inputTextStyle,
                    keyboardType: TextInputType.number,
                    onChanged: (_) =>
                        controller.clearFieldError('products.$index.value'),
                    validator: OrderValidators.validateNumber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Special Attributes Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Obx(() => FilterChip(
                  label: const Text("Battery", style: AppStyles.chipTextStyle),
                  selected: product.isBattery.value,
                  selectedColor: Theme.of(Get.context!).colorScheme.primaryContainer,
                  onSelected: (val) => product.isBattery.value = val,
                )),
                Obx(() => FilterChip(
                  label: const Text("Perfume", style: AppStyles.chipTextStyle),
                  selected: product.isPerfume.value,
                  selectedColor: Theme.of(Get.context!).colorScheme.primaryContainer,
                  onSelected: (val) => product.isPerfume.value = val,
                )),
                Obx(() => FilterChip(
                  label: const Text("Flammable", style: AppStyles.chipTextStyle),
                  selected: product.isFlameable.value,
                  selectedColor: Theme.of(Get.context!).colorScheme.primaryContainer,
                  onSelected: (val) => product.isFlameable.value = val,
                )),
              ],
            ),
            const SizedBox(height: 12),

            // Remove Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => controller.productController.removeProduct(index),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(Get.context!).colorScheme.error,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline, size: 18),
                    SizedBox(width: 4),
                    Text('Remove', style: AppStyles.dangerTextStyle),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(Get.context!).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}