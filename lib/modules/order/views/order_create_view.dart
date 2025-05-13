import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/app/app_colors.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';
import 'package:home_delivery_br/modules/order/views/BasicInfoForm.dart';
import 'package:home_delivery_br/modules/order/views/ParcelDetailsForm.dart';
import 'package:home_delivery_br/modules/order/views/SenderRecipientForm.dart';

class OrderCreateView extends GetView<OrderCreateController> {
  const OrderCreateView({super.key});
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = bottomPadding > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Order'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        centerTitle: true,
        elevation: 0,

      ),
      body: Column(
        children: [
          // Progress indicator with labels
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Obx(
                      () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
                      final isActive = controller.currentStep.value >= index;
                      return Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primary
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getStepLabel(index),
                            style: TextStyle(
                              fontSize: 12,
                              color: isActive
                                  ? AppColors.primary
                                  : Colors.grey.shade600,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                      () => LinearProgressIndicator(
                    value: (controller.currentStep.value + 1) / 3,
                    backgroundColor: Colors.grey.shade200,
                    color: AppColors.primary,
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),

          // Form content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Bottom action bar
          Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: isKeyboardOpen ? 16 : 24 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Obx(
                  () => Row(
                children: [
                  // Back button (only visible after first step)
                  if (controller.currentStep.value > 0)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: controller.previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),

                  if (controller.currentStep.value > 0)
                    const SizedBox(width: 12),

                  // Cancel button
                  if (controller.currentStep.value == 0)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),

                  if (controller.currentStep.value == 0)
                    const SizedBox(width: 12),

                  // Next/Create button
                  Expanded(
                    flex: controller.currentStep.value == 0 ? 2 : 1,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.currentStep.value == 2
                          ? () => controller.addOrder()
                          : controller.nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          );
                        }
                        return Text(
                          controller.currentStep.value == 2
                              ? 'Create Order'
                              : 'Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepLabel(int index) {
    switch (index) {
      case 0:
        return 'Basic Info';
      case 1:
        return 'Sender/Recipient';
      case 2:
        return 'Parcel Details';
      default:
        return '';
    }
  }
}