import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_create_controller.dart';
import 'package:simpl/modules/order/controllers/validators/order_validators.dart';

class BasicInfoForm extends GetView<OrderCreateController> {
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
            decoration:   InputDecoration(
              labelText: 'Tracking/Customer ID*',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),

              errorText: controller.getFieldError("parcel.tracking_id"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) {
              controller.clearFieldError('parcel.tracking_id');
            },
          ),
          const SizedBox(height: 16),

          // Weight and Shipment Value Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.weightController,
                  decoration:   InputDecoration(
                    labelText: 'Weight (kg)*',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    errorText: controller.getFieldError("parcel.weight"),
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                  onChanged: (_) {
                    controller.clearFieldError('parcel.weight');
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.shipmentValueController,
                  decoration: InputDecoration(
                    labelText: 'Shipment value (\$)*',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    errorText: controller.getFieldError("parcel.shipment_value"),
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                  onChanged: (_) {
                    controller.clearFieldError('parcel.shipment_value');
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
                  decoration:   InputDecoration(
                    labelText: 'Length',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    errorText: controller.getFieldError("parcel.length"),

                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                  onChanged: (_) {
                    controller.clearFieldError('parcel.length');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.widthController,
                  decoration:   InputDecoration(
                    labelText: 'Width',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    errorText: controller.getFieldError("parcel.width"),

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
                  decoration: InputDecoration(
                    labelText: 'Height',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    errorText: controller.getFieldError("parcel.height"),

                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                  onChanged: (_) {
                    controller.clearFieldError('parcel.height');
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