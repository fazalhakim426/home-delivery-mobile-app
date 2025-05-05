import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';
import 'package:simpl/modules/order/controllers/validators/order_validators.dart';

class SenderRecipientForm extends GetView<OrderController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.senderRecipientFormKey,
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          const Text('Sender Information', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.senderController.firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., Thomaz',
              errorText: _buildErrorText("sender.first_name"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("sender.first_name"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., Marques',
              errorText: _buildErrorText("sender.last_name"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("sender.last_name"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.emailController,
            decoration: InputDecoration(
              labelText: 'Email*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., contato@babylicio.us',
              errorText: _buildErrorText("sender.email"),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: OrderValidators.validateEmail,
            onChanged: (_) => controller.clearFieldError("sender.email"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.taxIdController,
            decoration: InputDecoration(
              labelText: 'Tax ID*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., 32786897807',
              errorText: _buildErrorText("sender.tax_id"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("sender.tax_id"),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final errorText = controller.fieldErrors["sender.country_id"];
            return DropdownButtonFormField<int>(
              value: controller.senderController.selectedCountryId.value,
              onChanged: (value) {
                controller.senderController.selectedCountryId.value = value!;
                // Optional: Clear error when a selection is made
                controller.clearFieldError("sender.country_id");
              },
              decoration: InputDecoration(
                labelText: 'Country',
                border: const OutlineInputBorder(),
                errorText: errorText, // Reactive error text
              ),
              items: controller.parcelController.countries
                  .map((country) => DropdownMenuItem(
                value: country.id,
                child: Text(country.name),
              ))
                  .toList(),
              validator: (value) => value == null ? 'Please select a country' : null,
            );
          }),


          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.websiteController,
            decoration: InputDecoration(
              labelText: 'Website*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., https://example.com',
              errorText: _buildErrorText("sender.sender_website"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("sender.sender_website"),
          ),

          const SizedBox(height: 24),
          const Text('Recipient Information', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.recipientController.firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., Alex',
              errorText: _buildErrorText("recipient.first_name"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("recipient.first_name"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., Hoyos',
              errorText: _buildErrorText("recipient.last_name"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("recipient.last_name"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.emailController,
            decoration: InputDecoration(
              labelText: 'Email*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., test@hd.com',
              errorText: _buildErrorText("recipient.email"),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: OrderValidators.validateEmail,
            onChanged: (_) => controller.clearFieldError("recipient.email"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.phoneController,
            decoration: InputDecoration(
              labelText: 'Phone*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., +5511937293951',
              errorText: _buildErrorText("recipient.phone"),
            ),
            keyboardType: TextInputType.phone,
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("recipient.phone"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.taxIdController,
            decoration: InputDecoration(
              labelText: 'Tax ID*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., 73489158172',
              errorText: _buildErrorText("recipient.tax_id"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("recipient.tax_id"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.cityController,
            decoration: InputDecoration(
              labelText: 'City*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., Brasilia',
              errorText: _buildErrorText("recipient.city"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("recipient.city"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.streetNoController,
            decoration: InputDecoration(
              labelText: 'Street No*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., 0',
              errorText: _buildErrorText("recipient.street_no"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("recipient.street_no"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.addressController,
            decoration: InputDecoration(
              labelText: 'Address*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., Cond Estancia...',
              errorText: _buildErrorText("recipient.address"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("recipient.address"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.address2Controller,
            decoration: const InputDecoration(
              labelText: 'Address Line 2',
              border: OutlineInputBorder(),
              hintText: 'e.g., Quadra 5...',
            ),
          ),
          const SizedBox(height: 12),

          Obx(() {
            final errorText = controller.getFieldError('recipient.account_type');
            return DropdownButtonFormField<String>(
              value: controller.recipientController.accountType.value,
              onChanged: (value) {
                controller.recipientController.accountType.value = value!;
                controller.clearFieldError("recipient.account_type");
              },
              decoration: InputDecoration(
                labelText: 'Account Type*',
                border: OutlineInputBorder(),
                errorText: errorText, // Now reactive
              ),
              items: const [
                DropdownMenuItem(value: 'individual', child: Text('Individual')),
                DropdownMenuItem(value: 'company', child: Text('Company')),
              ],
              validator: (value) => value == null ? 'Please select account type' : null,
            );
          }),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.zipCodeController,
            decoration: InputDecoration(
              labelText: 'Zipcode*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., 71680389',
              errorText: _buildErrorText("recipient.zipcode"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("recipient.zipcode"),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final errorText = controller.getFieldError("recipient.country_id");
            final countries = controller.parcelController.countries;
            final selectedValue = controller.recipientController.selectedCountryId.value;

            return DropdownButtonFormField<int>(
              value: countries.isEmpty ? null : selectedValue,
              onChanged: countries.isEmpty ? null : (value) {
                controller.recipientController.selectedCountryId.value = value!;
                controller.clearFieldError("recipient.country_id");
              },
              decoration: InputDecoration(
                labelText: 'Country*',
                border: const OutlineInputBorder(),
                errorText: errorText,
              ),
              items: countries.map((country) => DropdownMenuItem(
                value: country.id,
                child: Text(country.name),
              )).toList(),
              validator: (value) => value == null ? 'Please select a country' : null,
            );
          }),

          const SizedBox(height: 12),
          Obx(() {
            final errorText = controller.getFieldError("recipient.state_id");
            final states = controller.parcelController.states;
            final selectedValue = controller.recipientController.selectedStateId.value;

            return DropdownButtonFormField<int>(
              value: states.isEmpty ? null : selectedValue,
              onChanged: states.isEmpty ? null : (value) {
                controller.recipientController.selectedStateId.value = value!;
                controller.clearFieldError("recipient.state_id");
              },
              decoration: InputDecoration(
                labelText: 'State*',
                border: const OutlineInputBorder(),
                errorText: errorText,
              ),
              items: states.map((state) => DropdownMenuItem(
                value: state.id,
                child: Text(state.name),
              )).toList(),
              validator: (value) => value == null ? 'Please select a state' : null,
            );
          }),
         ],
      ),
    );
  }

  String? _buildErrorText(String fieldKey) {
    return controller.fieldErrors.containsKey(fieldKey) &&
        controller.fieldErrors[fieldKey]!.isNotEmpty
        ? controller.fieldErrors[fieldKey]
        : null;
  }
}