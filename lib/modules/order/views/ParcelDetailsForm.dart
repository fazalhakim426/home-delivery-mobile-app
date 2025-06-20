import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/app/app_styles.dart';
import 'package:home_delivery_br/data/models/ServiceModel.dart';
import 'package:home_delivery_br/data/models/ShCodeModel.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';
import 'package:home_delivery_br/modules/order/controllers/validators/order_validators.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../controllers/parcel_controller.dart';

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
              controller.mode == 'edit'
                  ? '${controller.order.warehouseNumber}'
                  : 'Shipping Details',
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
                    return buildShippingServiceDropdown(
                      context: context,
                      selectedServiceId:
                          controller.parcelController.selectedServiceId,
                      services: controller.parcelController.services,
                      getFieldError: controller.getFieldError,
                      clearFieldError: controller.clearFieldError,
                      colorScheme: Theme.of(context).colorScheme,
                      parcelController: controller.parcelController,
                    );
                  }),

                  const SizedBox(height: 40),

                  // Tax Modality Dropdown
                  Obx(() {
                    final errorText = controller.getFieldError(
                      'parcel.tax_modality',
                    );
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
                          value: 'ddu',
                          child: Text(
                            'Delivered Duty Unpaid (DDU)',
                            style: AppStyles.dropdownItemStyle,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'ddp',
                          child: Text(
                            'Delivered Duty Paid (DDP)',
                            style: AppStyles.dropdownItemStyle,
                          ),
                        ),
                      ],
                      validator:
                          (value) =>
                              value == null
                                  ? 'Please select tax modality'
                                  : null,
                    );
                  }),
                ],
              ),
            ),

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
                    style:
                        productsError != null
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
            Obx(() {
              return buildShCodeDropdown(
                selectedShCode: product.selectedShCode,
                shCodes: controller.parcelController.shCodes,
                index: index,
                getFieldError: controller.getFieldError,
                clearFieldError: controller.clearFieldError,
                parcelController: controller.parcelController,
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
                errorText: controller.getFieldError(
                  'products.$index.description',
                ),
              ),
              style: AppStyles.inputTextStyle,
              onChanged:
                  (_) =>
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
                      errorText: controller.getFieldError(
                        'products.$index.quantity',
                      ),
                    ),
                    style: AppStyles.inputTextStyle,
                    keyboardType: TextInputType.number,
                    onChanged:
                        (_) => controller.clearFieldError(
                          'products.$index.quantity',
                        ),
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
                      errorText: controller.getFieldError(
                        'products.$index.value',
                      ),
                    ),
                    style: AppStyles.inputTextStyle,
                    keyboardType: TextInputType.number,
                    onChanged:
                        (_) =>
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
                Obx(
                  () => FilterChip(
                    label: const Text(
                      "Battery",
                      style: AppStyles.chipTextStyle,
                    ),
                    selected: product.isBattery.value,
                    selectedColor:
                        Theme.of(Get.context!).colorScheme.primaryContainer,
                    onSelected: (val) => product.isBattery.value = val,
                  ),
                ),
                Obx(
                  () => FilterChip(
                    label: const Text(
                      "Perfume",
                      style: AppStyles.chipTextStyle,
                    ),
                    selected: product.isPerfume.value,
                    selectedColor:
                        Theme.of(Get.context!).colorScheme.primaryContainer,
                    onSelected: (val) => product.isPerfume.value = val,
                  ),
                ),
                Obx(
                  () => FilterChip(
                    label: const Text(
                      "Flammable",
                      style: AppStyles.chipTextStyle,
                    ),
                    selected: product.isFlameable.value,
                    selectedColor:
                        Theme.of(Get.context!).colorScheme.primaryContainer,
                    onSelected: (val) => product.isFlameable.value = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Remove Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed:
                    () => controller.productController.removeProduct(index),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(Get.context!).colorScheme.error,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
            ),
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
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget buildShippingServiceDropdown({
    required RxnInt selectedServiceId,
    required List<Service> services,
    required String? Function(String key) getFieldError,
    required void Function(String key) clearFieldError,
    required ColorScheme colorScheme,
    required BuildContext context,
    required ParcelController parcelController, // Add this parameter
  }) {
    final errorText = getFieldError("parcel.service_id");

    return FormField<int>(
      validator:
          (value) =>
              value == null || value == 0 ? 'Please select a service' : null,
      initialValue:
          selectedServiceId.value == 0 ? null : selectedServiceId.value,
      builder: (state) {
        return GestureDetector(
          onTap: () async {
            if (services.isEmpty) {
              await parcelController.fetchShippingServices();
              if (parcelController.services.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Failed to load shipping services. Please check your internet connection.',
                    ),
                  ),
                );
                return;
              }
            }
            // Proceed with showing the dropdown
            final selectedService = await showModalBottomSheet<Service>(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Search service',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            // Implement search functionality if needed
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: parcelController.services.length,
                          itemBuilder: (context, index) {
                            final service = parcelController.services[index];
                            return ListTile(
                              title: Text(service.name),
                              onTap: () {
                                Navigator.pop(context, service);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );

            if (selectedService != null) {
              selectedServiceId.value = selectedService.id;
              clearFieldError("parcel.service_id");
              state.didChange(selectedService.id);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Shipping Service',
              labelStyle: AppStyles.inputLabelStyle,
              prefixIcon: const Icon(Icons.local_shipping),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              errorText: errorText ?? state.errorText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            child: Text(
              services
                  .firstWhere(
                    (service) => service.id == selectedServiceId.value,
                    orElse:
                        () => Service(id: 0, name: 'Select shipping service'),
                  )
                  .name,
            ),
          ),
        );
      },
    );
  }

  Widget buildShCodeDropdown({
    required RxnInt selectedShCode,
    required List<ShCode> shCodes,
    required int index,
    required String? Function(String key) getFieldError,
    required void Function(String key) clearFieldError,
    required ParcelController parcelController, // Add this parameter
  }) {
    final errorText = getFieldError('products.$index.sh_code');
    final colorScheme = Theme.of(Get.context!).colorScheme;

    return FormField<int>(
      validator:
          (value) =>
              value == null || value == -1 ? 'Please select an SH code' : null,
      initialValue: selectedShCode.value == -1 ? null : selectedShCode.value,
      builder: (state) {
        return GestureDetector(
          onTap: () async {
            if (shCodes.isEmpty) {
              await parcelController
                  .fetchShCodes(); // Assuming you have this method
              if (parcelController.shCodes.isEmpty) {
                ScaffoldMessenger.of(Get.context!).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Failed to load SH codes. Please check your internet connection.',
                    ),
                  ),
                );
                return;
              }
            }

            // Proceed with showing the dropdown
            final selectedCode = await showModalBottomSheet<ShCode>(
              context: Get.context!,
              isScrollControlled: true,
              builder: (context) {
                return SizedBox(
                  height: Get.height * 0.6,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Search SH code',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            // Implement search functionality if needed
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: parcelController.shCodes.length,
                          itemBuilder: (context, index) {
                            final code = parcelController.shCodes[index];
                            return ListTile(
                              title: Text(code.description),
                              onTap: () {
                                Navigator.pop(context, code);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );

            if (selectedCode != null) {
              selectedShCode.value = selectedCode.code;
              clearFieldError('products.$index.sh_code');
              state.didChange(selectedCode.code);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'SH Code',
              labelStyle: AppStyles.inputLabelStyle,
              prefixIcon: const Icon(Icons.code),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              errorText: errorText ?? state.errorText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            child: Text(
              shCodes
                  .firstWhere(
                    (code) => code.code == selectedShCode.value,
                    orElse:
                        () => ShCode(code: -1, description: 'Select SH code'),
                  )
                  .description,
            ),
          ),
        );
      },
    );
  }
}
