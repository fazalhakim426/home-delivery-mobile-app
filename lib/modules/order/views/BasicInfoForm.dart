import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';
import 'package:simpl/modules/order/controllers/validators/order_validators.dart';

class BasicInfoForm extends GetView<OrderController> {
  const BasicInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.basicInfoFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Basic Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Tracking ID Field
          TextFormField(
            controller: controller.parcelController.trackingIdController,
            decoration: const InputDecoration(
              labelText: 'Tracking/Customer ID*',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) {
              // Clear error when user types
              controller.fieldErrors.remove('parcel.tracking_id');
              controller.update();
            },
          ),
          const SizedBox(height: 16),

          // Weight and Shipment Value Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)*',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                  onChanged: (_) {
                    controller.fieldErrors.remove('parcel.weight');
                    controller.update();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.shipmentValueController,
                  decoration: const InputDecoration(
                    labelText: 'Shipment value (\$)*',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                  onChanged: (_) {
                    controller.fieldErrors.remove('parcel.shipment_value');
                    controller.update();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dimensions Section
          Text(
            'Dimensions (cm)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.lengthController,
                  decoration: const InputDecoration(
                    labelText: 'Length',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                  onChanged: (_) {
                    controller.fieldErrors.remove('parcel.length');
                    controller.update();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.widthController,
                  decoration: const InputDecoration(
                    labelText: 'Width',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                  onChanged: (_) {
                    controller.fieldErrors.remove('parcel.width');
                    controller.update();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.heightController,
                  decoration: const InputDecoration(
                    labelText: 'Height',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                  onChanged: (_) {
                    controller.fieldErrors.remove('parcel.height');
                    controller.update();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}