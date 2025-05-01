
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';

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

