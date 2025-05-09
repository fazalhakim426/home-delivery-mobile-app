import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';
import 'package:home_delivery_br/modules/order/controllers/validators/order_validators.dart';

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
          // Section Header
          _buildSectionHeader(context, 'Basic Information'),
          const SizedBox(height: 24),

          // Tracking ID Field
          _buildTextField(
            context: context,
            textController: controller.parcelController.trackingIdController,
            label: 'Tracking/Customer ID*',
            fieldKey: 'parcel.tracking_id',
            validator: OrderValidators.validateRequired,
          ),
          const SizedBox(height: 20),

          // Weight and Shipment Value Row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context: context,
                  textController: controller.parcelController.weightController,
                  label: 'Weight (kg)*',
                  fieldKey: 'parcel.weight',
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  context: context,
                  textController: controller.parcelController.shipmentValueController,
                  label: 'Shipment value (\$)*',
                  fieldKey: 'parcel.shipment_value',
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Dimensions Section
          _buildSectionSubheader(context, 'Dimensions (cm)'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context: context,
                  textController: controller.parcelController.lengthController,
                  label: 'Length',
                  fieldKey: 'parcel.length',
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  textController: controller.parcelController.widthController,
                  label: 'Width',
                  fieldKey: 'parcel.width',
                  keyboardType: TextInputType.number,
                  validator: OrderValidators.validateNumber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  context: context,
                  textController: controller.parcelController.heightController,
                  label: 'Height',
                  fieldKey: 'parcel.height',
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

  // Helper method for section headers
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // Helper method for section subheaders
  Widget _buildSectionSubheader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
      ),
    );
  }

  // Helper method for text fields
  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController textController,
    required String label,
    required String fieldKey,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
        errorText: controller.getFieldError(fieldKey),
        errorMaxLines: 2,
      ),
      keyboardType: keyboardType,
      validator: validator,
      onChanged: (_) => controller.clearFieldError(fieldKey),
    );
  }
}