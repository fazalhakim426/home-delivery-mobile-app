import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';

class OrderCreateView extends GetView<OrderController> {
  const OrderCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    // Load saved form data when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.loadSavedFormData();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Step Indicator
            Obx(
              () => Row(
                children: [
                  for (int i = 0; i < 3; i++)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 4,
                        decoration: BoxDecoration(
                          color: controller.currentStep.value >= i
                              ? Colors.indigo
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Steps
            Obx(() {
              switch (controller.currentStep.value) {
                case 0:
                  return _BasicInfoForm();
                case 1:
                  return _SenderRecipientForm();
                case 2:
                  return _ParcelDetailsForm();
                default:
                  return const SizedBox();
              }
            }),

            // Navigation Buttons
            const SizedBox(height: 24),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.currentStep.value > 0)
                    TextButton(
                      onPressed: controller.previousStep,
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.currentStep.value == 2
                        ? () {
                      controller.addOrder();
                    }
                        : controller.nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Obx(() => Text(
                      controller.isLoading.value
                          ? 'Loading...'
                          : controller.currentStep.value == 2 ? 'Create' : 'Next',
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BasicInfoForm extends GetView<OrderController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.basicInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Obx(() => TextFormField(
            controller: controller.trackingIdController,
            onChanged: (_) => controller.fieldErrors.remove('parcel.tracking_id'),
            decoration: InputDecoration(
              labelText: 'Tracking/Customer ID*',
              border: const OutlineInputBorder(),
              errorText: controller.fieldErrors['parcel.tracking_id'],
            ),
            validator: controller.validateRequired,
          )),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)*',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: controller.validateNumber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller.shipmentValueController,
                  decoration: const InputDecoration(
                    labelText: 'Shipment value (\$)*',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: controller.validateNumber,
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
                child: TextFormField(
                  controller: controller.lengthController,
                  decoration: const InputDecoration(
                    labelText: 'Length',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: controller.validateNumber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller.widthController,
                  decoration: const InputDecoration(
                    labelText: 'Width',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: controller.validateNumber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller.heightController,
                  decoration: const InputDecoration(
                    labelText: 'Height',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: controller.validateNumber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// class _ParcelDetailsForm extends GetView<OrderController> {
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: controller.parcelDetailsFormKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const Text(
//             'Parcel Details',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: controller.weightController,
//                   decoration: const InputDecoration(
//                     labelText: 'Weight (kg)*',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: controller.validateNumber,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: TextFormField(
//                   controller: controller.shipmentValueController,
//                   decoration: const InputDecoration(
//                     labelText: 'Value (\$)*',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: controller.validateNumber,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           const Text('Dimensions (cm)', style: TextStyle(fontSize: 14)),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: controller.lengthController,
//                   decoration: const InputDecoration(
//                     labelText: 'Length',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: controller.validateNumber,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: TextFormField(
//                   controller: controller.widthController,
//                   decoration: const InputDecoration(
//                     labelText: 'Width',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: controller.validateNumber,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: TextFormField(
//                   controller: controller.heightController,
//                   decoration: const InputDecoration(
//                     labelText: 'Height',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: controller.validateNumber,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


class _SenderRecipientForm extends GetView<OrderController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.senderRecipientFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Sender Information',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.senderNameController,
            decoration: const InputDecoration(
              labelText: 'Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., John Doe',
            ),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderEmailController,
            decoration: const InputDecoration(
              labelText: 'Email*',
              border: OutlineInputBorder(),
              hintText: 'e.g., john@example.com',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),
          const SizedBox(height: 24),
          const Text(
            'Recipient Information',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.recipientNameController,
            decoration: const InputDecoration(
              labelText: 'Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., Jane Doe',
            ),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientEmailController,
            decoration: const InputDecoration(
              labelText: 'Email*',
              border: OutlineInputBorder(),
              hintText: 'e.g., jane@example.com',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone*',
              border: OutlineInputBorder(),
              hintText: 'e.g., +1234567890',
            ),
            keyboardType: TextInputType.phone,
            validator: controller.validateRequired,
          ),
        ],
      ),
    );
  }
}


class _ParcelDetailsForm extends GetView<OrderController> {
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