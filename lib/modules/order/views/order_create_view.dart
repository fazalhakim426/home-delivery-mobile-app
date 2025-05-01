import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';
import 'package:simpl/modules/order/views/BasicInfoForm.dart';
import 'package:simpl/modules/order/views/ParcelDetailsForm.dart';
import 'package:simpl/modules/order/views/SenderRecipientForm.dart';

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
                  return BasicInfoForm();
                case 1:
                  return SenderRecipientForm();
                case 2:
                  return ParcelDetailsForm();
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