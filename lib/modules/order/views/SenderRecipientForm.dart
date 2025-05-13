import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';
import 'package:home_delivery_br/modules/order/controllers/validators/order_validators.dart';

class SenderRecipientForm extends GetView<OrderCreateController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.senderRecipientFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sender Information Section
            _buildSectionHeader(context, 'Sender Information'),
            const SizedBox(height: 16),

            // Sender Form Fields
            _buildTextFormField(
              context: context,
              controller: controller.senderController.firstNameController,
              label: 'First Name*',
              hintText: 'e.g., Thomaz',
              fieldKey: 'sender.first_name',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.senderController.lastNameController,
              label: 'Last Name*',
              hintText: 'e.g., Marques',
              fieldKey: 'sender.last_name',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.senderController.emailController,
              label: 'Email*',
              hintText: 'e.g., contato@babylicio.us',
              fieldKey: 'sender.email',
              keyboardType: TextInputType.emailAddress,
              validator: OrderValidators.validateEmail,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.senderController.taxIdController,
              label: 'Tax ID*',
              hintText: 'e.g., 32786897807',
              fieldKey: 'sender.tax_id',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.senderController.websiteController,
              label: 'Website*',
              hintText: 'e.g., https://example.com',
              fieldKey: 'sender.sender_website',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildCountryDropdown(
              context: context,
              selectedValue: controller.senderController.selectedCountryId.value,
              onChanged: (value) {
                if (value != null) {
                  controller.senderController.selectedCountryId.value = value;
                  controller.clearFieldError("sender.country_id");
                }
              },
              fieldKey: 'sender.country_id',
            ),

            // Recipient Information Section
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Recipient Information'),
            const SizedBox(height: 16),

            // Recipient Form Fields
            _buildTextFormField(
              context: context,
              controller: controller.recipientController.firstNameController,
              label: 'First Name*',
              hintText: 'e.g., Alex',
              fieldKey: 'recipient.first_name',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.recipientController.lastNameController,
              label: 'Last Name*',
              hintText: 'e.g., Hoyos',
              fieldKey: 'recipient.last_name',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.recipientController.emailController,
              label: 'Email*',
              hintText: 'e.g., test@hd.com',
              fieldKey: 'recipient.email',
              keyboardType: TextInputType.emailAddress,
              validator: OrderValidators.validateEmail,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.recipientController.phoneController,
              label: 'Phone*',
              hintText: 'e.g., +5511937293951',
              fieldKey: 'recipient.phone',
              keyboardType: TextInputType.phone,
              validator: OrderValidators.validatePhone,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.recipientController.taxIdController,
              label: 'Tax ID*',
              hintText: 'e.g., 73489158172',
              fieldKey: 'recipient.tax_id',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.recipientController.cityController,
              label: 'City*',
              hintText: 'e.g., Brasilia',
              fieldKey: 'recipient.city',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.recipientController.streetNoController,
              label: 'Street No*',
              hintText: 'e.g., 0',
              fieldKey: 'recipient.street_no',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.recipientController.addressController,
              label: 'Address*',
              hintText: 'e.g., Cond Estancia...',
              fieldKey: 'recipient.address',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.recipientController.address2Controller,
              label: 'Address Line 2',
              hintText: 'e.g., Quadra 5...',
            ),
            const SizedBox(height: 12),
            _buildAccountTypeDropdown(context),
            const SizedBox(height: 12),
            _buildTextFormField(
              context: context,
              controller: controller.recipientController.zipCodeController,
              label: 'Zipcode*',
              hintText: 'e.g., 71680389',
              fieldKey: 'recipient.zipcode',
              validator: OrderValidators.validateRequired,
            ),
            const SizedBox(height: 12),
            _buildCountryDropdown(
              context: context,
              selectedValue: controller.recipientController.selectedCountryId.value,
              onChanged: (value) {
                if (value != null) {
                  controller.recipientController.selectedCountryId.value = value;
                  controller.fetchCountryStats(value);
                  controller.clearFieldError("recipient.country_id");
                }
              },
              fieldKey: 'recipient.country_id',
            ),
            const SizedBox(height: 12),
            _buildStateDropdown(context),
          ],
        ),
      )
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    String? hintText,
    String? fieldKey,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
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
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
        ),
        errorText: fieldKey != null ? this.controller.getFieldError(fieldKey) : null,
        errorMaxLines: 2,
      ),
      keyboardType: keyboardType,
      validator: validator,
      onChanged: fieldKey != null ? (_) => this.controller.clearFieldError(fieldKey) : null,
    );
  }

  Widget _buildCountryDropdown({
    required BuildContext context,
    required int? selectedValue,
    required ValueChanged<int?> onChanged,
    required String fieldKey,
  }) {
    return Obx(() {
      final errorText = controller.getFieldError(fieldKey);
      final countries = controller.parcelController.countries;

      return DropdownButtonFormField<int>(
        value: selectedValue != 0 ? selectedValue : null,
        onChanged: countries.isEmpty ? null : onChanged,
        decoration: InputDecoration(
          labelText: 'Country*',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
          errorText: errorText,
          errorMaxLines: 2,
        ),
        items: countries.map((country) => DropdownMenuItem<int>(
          value: country.id,
          child: Tooltip( // Added tooltip for very long names
            message: country.name,
            child: Text(
              country.name,
              overflow: TextOverflow.ellipsis, // Prevent overflow
              maxLines: 1,
              softWrap: false,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        )).toList(),
        validator: (value) => value == null ? 'Please select a country' : null,
        isExpanded: true,
        hint: Text(
          'Select country',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).hintColor,
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down),
        dropdownColor: Theme.of(context).colorScheme.surface,
        style: Theme.of(context).textTheme.bodyMedium,
        borderRadius: BorderRadius.circular(8),
      );
    });
  }


  Widget _buildAccountTypeDropdown(BuildContext context) {
    return Obx(() {
      final errorText = controller.getFieldError('recipient.account_type');

      return DropdownButtonFormField<String>(
        value: controller.recipientController.accountType.value,
        onChanged: (value) {
          controller.recipientController.accountType.value = value!;
          controller.clearFieldError("recipient.account_type");
        },
        decoration: InputDecoration(
          labelText: 'Account Type*',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          errorText: errorText,
        ),
        items: const [
          DropdownMenuItem(
            value: 'individual',
            child: Text('Individual'),
          ),
          DropdownMenuItem(
            value: 'company',
            child: Text('Company'),
          ),
        ],
        validator: (value) => value == null ? 'Please select account type' : null,
        isExpanded: true,
        hint: Text(
          'Select account type',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).hintColor,
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down),
        dropdownColor: Theme.of(context).colorScheme.surface,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    });
  }

  Widget _buildStateDropdown(BuildContext context) {
    return Obx(() {
      final errorText = controller.getFieldError("recipient.state_id");
      final states = controller.parcelController.recipientStates;
      final selectedValue = controller.recipientController.selectedStateId.value;
      final isValidSelection = selectedValue != 0 && states.any((state) => state.id == selectedValue);

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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          errorText: errorText,
          suffixIcon: controller.isLoading.value
              ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : null,
        ),
        items: [
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
        hint: Text(
          'Select state',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).hintColor,
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down),
        dropdownColor: Theme.of(context).colorScheme.surface,
        style: Theme.of(context).textTheme.bodyMedium,

      );
    });
  }
}