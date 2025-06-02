import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/app/app_colors.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';
import 'package:home_delivery_br/modules/order/views/BasicInfoForm.dart';
import 'package:home_delivery_br/modules/order/views/ParcelDetailsForm.dart';
import 'package:home_delivery_br/modules/order/views/SenderRecipientForm.dart';
import 'package:home_delivery_br/routes/app_pages.dart';
import 'package:home_delivery_br/widgets/app_scaffold.dart';

import '../../../app/app_styles.dart';
class OrderCreateView extends GetView<OrderCreateController> {
  const OrderCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
                              color:
                                  isActive
                                      ? AppColors.primary
                                      : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color:
                                      isActive
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
                              color:
                                  isActive
                                      ? AppColors.primary
                                      : Colors.grey.shade600,
                              fontWeight:
                                  isActive
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


          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 24,
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
                          style: AppStyles.outlinedButtonStyle,
                          child: const Text(
                              'Back',
                              style: AppStyles.grayText1
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
                          onPressed: () => Get.toNamed(Routes.DASHBOARD),
                          style: AppStyles.outlinedButtonStyle,
                          child: const Text(
                              'CANCEL',
                              style: AppStyles.grayText1
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
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          shadowColor: AppColors.primary.withOpacity(0.3),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            );
                          }
                          return Text(
                            controller.currentStep.value == 2 ? 'SUBMIT' : 'Next',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
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
