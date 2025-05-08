import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_create_controller.dart';
import 'package:simpl/modules/order/controllers/validators/order_validators.dart';

class SenderRecipientForm extends GetView<OrderCreateController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.senderRecipientFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          const Text('Sender Information', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.senderController.firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., Thomaz',
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("sender.first_name"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., Marques',
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("sender.last_name"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.emailController,
            decoration: const InputDecoration(
              labelText: 'Email*',
              border: OutlineInputBorder(),
              hintText: 'e.g., contato@babylicio.us',
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              errorText: controller.getFieldError("sender.tax_id"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("sender.tax_id"),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final errorText = controller.fieldErrors["sender.country_id"];
            return DropdownButtonFormField<int>(
              // Use .value with proper null handling
              value: controller.senderController.selectedCountryId.value != 0
                  ? controller.senderController.selectedCountryId.value
                  : null,

              onChanged: controller.parcelController.countries.isEmpty
                  ? null // Disable dropdown if no countries are loaded
                  : (value) {
                if (value != null) {
                  controller.senderController.selectedCountryId.value = value;
                  controller.clearFieldError("sender.country_id");
                }
              },

              decoration: InputDecoration(
                labelText: 'Country*', // Added * to indicate required field
                border: const OutlineInputBorder(),
                errorText: errorText,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16), // Better padding

              ),

              items: controller.parcelController.countries
                  .map((country) => DropdownMenuItem<int>(
                value: country.id,
                child: Text(
                  country.name,
                  overflow: TextOverflow.ellipsis, // Prevent text overflow
                ),
              ))
                  .toList(),

              validator: (value) => value == null ? 'Please select a country' : null,

              // UI/UX improvements
              isExpanded: true, // Prevents overflow by expanding dropdown width
              hint: const Text('Select a country'), // Shows when no value is selected
              icon: const Icon(Icons.arrow_drop_down), // Custom dropdown icon
              style: Theme.of(context).textTheme.bodyMedium, // Themed text
              dropdownColor: Theme.of(context).colorScheme.surface, // Match theme
            );
          }),


          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.websiteController,
            decoration: InputDecoration(
              labelText: 'Website*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., https://example.com',
              errorText: controller.getFieldError("sender.sender_website"),
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
              errorText: controller.getFieldError("recipient.first_name"),
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
              errorText: controller.getFieldError("recipient.last_name"),
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
              errorText: controller.getFieldError("recipient.email"),
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
              errorText: controller.getFieldError("recipient.phone"),
            ),
            keyboardType: TextInputType.phone,
            validator: OrderValidators.validatePhone,
            onChanged: (_) => controller.clearFieldError("recipient.phone"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.taxIdController,
            decoration: InputDecoration(
              labelText: 'Tax ID*',
              border: const OutlineInputBorder(),
              hintText: 'e.g., 73489158172',
              errorText: controller.getFieldError("recipient.tax_id"),
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
              errorText: controller.getFieldError("recipient.city"),
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
              errorText: controller.getFieldError("recipient.street_no"),
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
              errorText: controller.getFieldError("recipient.address"),
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
              errorText: controller.getFieldError("recipient.zipcode"),
            ),
            validator: OrderValidators.validateRequired,
            onChanged: (_) => controller.clearFieldError("recipient.zipcode"),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final errorText = controller.getFieldError("recipient.country_id");
            final countries = controller.parcelController.countries;
            final selectedValue = controller.recipientController.selectedCountryId.value;

            return
              DropdownButtonFormField<int>(
                value: selectedValue, // Make sure selectedValue can be null initially
                onChanged: countries.isEmpty
                    ? null
                    : (value) {
                  if (value != null) {
                    controller.recipientController.selectedCountryId.value = value;
                    controller.fetchCountryStats(value);
                    controller.clearFieldError("recipient.country_id");
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Country*',
                  border: const OutlineInputBorder(),
                  errorText: errorText,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16), // Add padding
                ),
                items: countries.isEmpty
                    ? [] // Return empty list if countries is empty
                    : countries.map((country) => DropdownMenuItem<int>(
                  value: country.id,
                  child: Text(
                    country.name,
                    overflow: TextOverflow.ellipsis, // Handle long country names
                  ),
                )).toList(),
                validator: (value) => value == null ? 'Please select a country' : null,
                isExpanded: true, // Important for proper dropdown width
                hint: const Text('Select a country'), // Show hint when no value is selected
                icon: const Icon(Icons.arrow_drop_down), // Custom dropdown icon
                style: Theme.of(context).textTheme.bodyMedium, // Use theme text style
              );
          }),

          const SizedBox(height: 12),
          Obx(() {
            final errorText = controller.getFieldError("recipient.state_id");
            final states = controller.parcelController.recipientStates;
            final selectedValue = controller.recipientController.selectedStateId.value;

            // Validate that the selected value exists in the states list
            final isValidSelection = selectedValue != 0 &&
                states.any((state) => state.id == selectedValue);

            return DropdownButtonFormField<int>(
              value: isValidSelection ? selectedValue : null,
              onChanged: states.isEmpty
                  ? null
                  : (value) {
                if (value != null) {
                  controller.recipientController.selectedStateId.value = value;
                  controller.clearFieldError("recipient.state_id");
                }
              },
              decoration: InputDecoration(
                labelText: 'State*',
                border: const OutlineInputBorder(),
                errorText: errorText,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                suffixIcon: controller.isLoading.value
                    ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : null,
              ),
              items: [
                // Add an empty option if no valid selection exists
                if (!isValidSelection)
                  DropdownMenuItem<int>(
                    value: null,
                    child: Text(
                      'Select state',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ...states.map((state) => DropdownMenuItem<int>(
                  value: state.id,
                  child: Text(
                    state.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )),
              ],
              validator: (value) {
                if (states.isEmpty) return 'No states available for this country';
                if (value == null) return 'Please select a state';
                return null;
              },
              isExpanded: true,
              hint: const Text('Select state'),
              icon: const Icon(Icons.arrow_drop_down),
              dropdownColor: Theme.of(context).colorScheme.surface,
              style: Theme.of(context).textTheme.bodyMedium,
            );
          })
         ],
      ),
    );
  }


}