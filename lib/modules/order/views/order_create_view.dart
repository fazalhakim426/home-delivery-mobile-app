import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/app/app_colors.dart';
import 'package:simpl/app/app_colors.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';
import 'package:simpl/modules/order/views/BasicInfoForm.dart';
import 'package:simpl/modules/order/views/ParcelDetailsForm.dart';
import 'package:simpl/modules/order/views/SenderRecipientForm.dart';

class OrderCreateView extends GetView<OrderController> {
  const OrderCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = bottomPadding > 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(

        children: [

          const SizedBox(height: 12),
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
                            ? AppColors.primary
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Step indicator

                  // Form content
                  Obx(() {
                    switch (controller.currentStep.value) {
                      case 0:
                        return  BasicInfoForm();
                      case 1:
                        return  SenderRecipientForm();
                      case 2:
                        return ParcelDetailsForm();
                      default:
                        return const SizedBox();
                    }
                  }),
                  const SizedBox(height: 80), // Extra space for bottom buttons
                ],
              ),
            ),
          ),

          // Fixed bottom navigation bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: isKeyboardOpen ? 12 : 50, // Equal top/bottom when keyboard is open
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Obx(
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
                    )
                  else
                    const SizedBox(width: 72),

                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.currentStep.value == 2
                        ? () => controller.addOrder()
                        : controller.nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      minimumSize: const Size(120, 48),
                    ),
                    child: Obx(() => Text(
                      controller.isLoading.value
                          ? 'Loading...'
                          : controller.currentStep.value == 2
                          ? 'Create'
                          : 'Next',
                      style: const TextStyle(fontSize: 16),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}