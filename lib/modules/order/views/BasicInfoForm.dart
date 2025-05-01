import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';
import 'package:simpl/modules/order/controllers/validators/order_validators.dart';

class BasicInfoForm extends GetView<OrderController> {
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

          // Remove Obx since we're not observing any reactive variables here
          TextFormField(
            controller: controller.parcelController.trackingIdController,
            decoration: InputDecoration(
              labelText: 'Tracking/Customer ID*',
              border: const OutlineInputBorder(),
              // If you need to show errors from the controller
              errorText: controller.fieldErrors['parcel.tracking_id'],
            ),
            validator: OrderValidators.validateRequired,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.weightController,
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)*',
                    border: const OutlineInputBorder(),
                    errorText: controller.fieldErrors['parcel.weight'],
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.shipmentValueController,
                  decoration: InputDecoration(
                    labelText: 'Shipment value (\$)*',
                    border: const OutlineInputBorder(),
                    errorText: controller.fieldErrors['parcel.shipment_value'],
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
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
                  controller: controller.parcelController.lengthController,
                  decoration: InputDecoration(
                    labelText: 'Length',
                    border: const OutlineInputBorder(),
                    errorText: controller.fieldErrors['parcel.length'],
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.widthController,
                  decoration: InputDecoration(
                    labelText: 'Width',
                    border: const OutlineInputBorder(),
                    errorText: controller.fieldErrors['parcel.width'],
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: controller.parcelController.heightController,
                  decoration: InputDecoration(
                    labelText: 'Height',
                    border: const OutlineInputBorder(),
                    errorText: controller.fieldErrors['parcel.height'],
                  ),
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}