import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_delivery_br/data/models/CountryModel.dart';
import 'package:home_delivery_br/data/models/CountryStateModel.dart';
import 'package:home_delivery_br/modules/order/controllers/order_create_controller.dart';
import 'package:home_delivery_br/modules/order/controllers/validators/order_validators.dart';

class SenderRecipientForm extends GetView<OrderCreateController> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.senderRecipientFormKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader(context, controller.mode=='edit'?'Edit ${controller.order.warehouseNumber}': 'Sender Information'),
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
                hintText: 'e.g., contato@example.com',
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
                label: 'Website',
                hintText: 'e.g., https:://example.com',
                fieldKey: 'sender.sender_website'
              ),
              const SizedBox(height: 12),
              _buildCountryDropdown(
                context: context,
                selectedValue: controller.senderController.selectedCountryId,
                onChanged: (value) {
                  if (value != null) {
                    controller.senderController.selectedCountryId.value = value;
                    controller.clearFieldError("sender.country_id");
                  }
                },
                fieldKey: 'sender.country_id',
                isSender: true,
                validator: (value) {
                  if (value == null || value == 0) {
                    return 'Country is required';
                  }
                  return null;
                },
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
                hintText: 'e.g., test@example.com',
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
                selectedValue: controller.recipientController.selectedCountryId,
                onChanged: (value) {
                  if (value != null && value != controller.recipientController.selectedCountryId.value) {
                    controller.recipientController.selectedCountryId.value = value;
                    controller.fetchCountryStats(value);
                    controller.clearFieldError("recipient.country_id");
                  }
                },
                fieldKey: 'recipient.country_id',
                isSender: false,
                validator: (value) {
                  if (value == null || value == 0) {
                    return 'Country is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildStateDropdown(context),
            ],
          ),
        )
    );
  }


  Widget _buildCountryDropdown({
    required BuildContext context,
    required RxInt selectedValue,
    required ValueChanged<int?> onChanged,
    required String fieldKey,
    required bool isSender,
    String? Function(int?)? validator, // <-- accept a validator
  }) {
    return Obx(() {
      final countries = controller.parcelController.countries;

      return FormField<int>(
        validator: validator, // <-- use it
        initialValue: selectedValue.value == 0 ? null : selectedValue.value,
        builder: (state) {
          return GestureDetector(
            onTap: () async {
              if (countries.isEmpty) {
                await controller.fetchCountries();
                if (controller.parcelController.countries.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to load countries. Please check your internet connection.')),
                  );
                  return;
                }
              }

              _showCountrySelectionModal(
                context: context,
                countries: countries,
                selectedValue: selectedValue.value,
                onChanged: (val) {
                  onChanged(val);
                  state.didChange(val); // important for validation
                },
                isSender: isSender,
              );
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Country*',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                errorText: state.errorText,
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              child: Text(
                _getCountryText(selectedValue.value, countries),
                overflow: TextOverflow.ellipsis,
                style: _getTextStyle(context, selectedValue.value),
              ),
            ),
          );
        },
      );
    });
  }

  String _getCountryText(int? selectedValue, List<Country> countries) {
    if (selectedValue != null && selectedValue != 0) {
      return countries.firstWhere(
            (c) => c.id == selectedValue,
        orElse: () => countries.isNotEmpty
            ? countries.first
            : Country(id: 0, name: 'No countries available', code: ''),
      ).name;
    }
    return countries.isNotEmpty ? 'Select country' : 'Tap to load countries';
  }

  TextStyle? _getTextStyle(BuildContext context, int? selectedValue) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: selectedValue != null && selectedValue != 0
          ? Theme.of(context).textTheme.bodyMedium?.color
          : Theme.of(context).hintColor,
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

  void _showCountrySelectionModal({
    required BuildContext context,
    required List<Country> countries,
    required int? selectedValue,
    required ValueChanged<int?> onChanged,
    required bool isSender,
  }) {
    final TextEditingController searchController = TextEditingController();
    final RxList<Country> filteredCountries = RxList<Country>(countries);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Obx(() {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search country',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    filteredCountries.value = countries
                        .where((country) => country.name.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredCountries.isEmpty
                      ? const Center(child: Text('No countries found'))
                      : ListView.builder(
                    itemCount: filteredCountries.length,

                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      return ListTile(
                        title: Text(country.name),
                        trailing: selectedValue == country.id
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          onChanged(country.id);
                          Navigator.pop(context);
                          // Only refresh the appropriate controller
                          if (isSender) {
                            controller.senderController.selectedCountryId.refresh();
                          } else {
                            controller.recipientController.selectedCountryId.refresh();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
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
            value: 'business',
            child: Text('Business'),
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
      final isLoading = controller.isLoading.value;

      // Determine if the selected value is valid
      final isValidSelection = selectedValue != 0 &&
          states.any((state) => state.id == selectedValue);

      return GestureDetector(
        onTap: isLoading || states.isEmpty
            ? null
            : () => _showSearchableStateDialog(
          context: context,
          countryStates: states, // Changed parameter name
          selectedValue: selectedValue ?? 0, // Handle null case
          isLoading: isLoading,
          onChanged: (value) {
            if (value != null) {
              controller.recipientController.selectedStateId.value = value;
              controller.clearFieldError("recipient.state_id");
            }
          },
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'State*',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            errorText: errorText,
            errorMaxLines: 2,
            suffixIcon: isLoading
                ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.arrow_drop_down),
          ),
          child: Text(
            isValidSelection
                ? states.firstWhere(
                    (s) => s.id == selectedValue,
                orElse: () => CountryState(id: 0, name: '',code: '')).name
                : 'Select state',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isValidSelection
                  ? null
                  : Theme.of(context).hintColor,
            ),
          ),
        ),
      );
    });
  }

  void _showSearchableStateDialog({
    required BuildContext context,
    required List<CountryState> countryStates,
    required int selectedValue,
    required bool isLoading,
    required ValueChanged<int?> onChanged,
  }) {
    final TextEditingController searchController = TextEditingController();
    List<CountryState> filteredStates = List.from(countryStates);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search field
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search state...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  filteredStates = countryStates
                      .where((state) => state.name
                      .toLowerCase()
                      .contains(value.toLowerCase()))
                      .toList();
                  (context as Element).markNeedsBuild();
                },
              ),
              const SizedBox(height: 16),

              // Loading or content
              if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (filteredStates.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      searchController.text.isEmpty
                          ? 'No states available'
                          : 'No matching states found',
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredStates.length,
                    itemBuilder: (context, index) {
                      final state = filteredStates[index];
                      return ListTile(
                        title: Text(state.name),
                        trailing: selectedValue == state.id
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          onChanged(state.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),

              // Close button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}