
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';
import 'package:simpl/modules/order/controllers/validators/order_validators.dart';

class SenderRecipientForm extends GetView<OrderController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.senderRecipientFormKey,
      child: Column(
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
            ),
            validator: OrderValidators.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., Marques',
            ),
            validator: OrderValidators.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.emailController,
            decoration: const InputDecoration(
              labelText: 'Email*',
              border: OutlineInputBorder(),
              hintText: 'e.g., contato@babylicio.us',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: OrderValidators.validateEmail,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.taxIdController,
            decoration: const InputDecoration(
              labelText: 'Tax ID*',
              border: OutlineInputBorder(),
              hintText: 'e.g., 32786897807',
            ),
            validator: OrderValidators.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.countryIdController,
            decoration: const InputDecoration(
              labelText: 'Country ID*',
              border: OutlineInputBorder(),
              hintText: 'e.g., US',
            ),
            validator: OrderValidators.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderController.websiteController,
            decoration: const InputDecoration(
              labelText: 'Website',
              border: OutlineInputBorder(),
              hintText: 'e.g., https://example.com',
            ),
          ),

          const SizedBox(height: 24),
          const Text('Recipient Information', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.recipientController.firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., Alex',
            ),
            validator: OrderValidators.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., Hoyos',
            ),
            validator: OrderValidators.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.emailController,
            decoration: const InputDecoration(
              labelText: 'Email*',
              border: OutlineInputBorder(),
              hintText: 'e.g., test@hd.com',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: OrderValidators.validateEmail,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone*',
              border: OutlineInputBorder(),
              hintText: 'e.g., +5511937293951',
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.taxIdController,
            decoration: const InputDecoration(
              labelText: 'Tax ID',
              border: OutlineInputBorder(),
              hintText: 'e.g., 73489158172',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.cityController,
            decoration: const InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(),
              hintText: 'e.g., Brasilia',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.streetNoController,
            decoration: const InputDecoration(
              labelText: 'Street No',
              border: OutlineInputBorder(),
              hintText: 'e.g., 0',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
              hintText: 'e.g., Cond Estancia...',
            ),
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
          TextFormField(
            controller: controller.recipientController.accountTypeController,
            decoration: const InputDecoration(
              labelText: 'Account Type',
              border: OutlineInputBorder(),
              hintText: 'e.g., individual',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.zipCodeController,
            decoration: const InputDecoration(
              labelText: 'Zipcode',
              border: OutlineInputBorder(),
              hintText: 'e.g., 71680389',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.stateIdController,
            decoration: const InputDecoration(
              labelText: 'State ID',
              border: OutlineInputBorder(),
              hintText: 'e.g., 509',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientController.countryIdController,
            decoration: const InputDecoration(
              labelText: 'Country ID',
              border: OutlineInputBorder(),
              hintText: 'e.g., 30',
            ),
          ),
        ],
      ),
    );
  }
}