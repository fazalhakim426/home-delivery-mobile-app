
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simpl/modules/order/controllers/order_controller.dart';

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
            controller: controller.senderFirstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., Thomaz',
            ),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderLastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., Marques',
            ),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderEmailController,
            decoration: const InputDecoration(
              labelText: 'Email*',
              border: OutlineInputBorder(),
              hintText: 'e.g., contato@babylicio.us',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderTaxIdController,
            decoration: const InputDecoration(
              labelText: 'Tax ID*',
              border: OutlineInputBorder(),
              hintText: 'e.g., 32786897807',
            ),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderCountryIdController,
            decoration: const InputDecoration(
              labelText: 'Country ID*',
              border: OutlineInputBorder(),
              hintText: 'e.g., US',
            ),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.senderWebsiteController,
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
            controller: controller.recipientFirstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., Alex',
            ),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientLastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name*',
              border: OutlineInputBorder(),
              hintText: 'e.g., Hoyos',
            ),
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientEmailController,
            decoration: const InputDecoration(
              labelText: 'Email*',
              border: OutlineInputBorder(),
              hintText: 'e.g., test@hd.com',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientPhoneController,
            decoration: const InputDecoration(
              labelText: 'Phone*',
              border: OutlineInputBorder(),
              hintText: 'e.g., +5511937293951',
            ),
            keyboardType: TextInputType.phone,
            validator: controller.validateRequired,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientTaxIdController,
            decoration: const InputDecoration(
              labelText: 'Tax ID',
              border: OutlineInputBorder(),
              hintText: 'e.g., 73489158172',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientCityController,
            decoration: const InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(),
              hintText: 'e.g., Brasilia',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientStreetNoController,
            decoration: const InputDecoration(
              labelText: 'Street No',
              border: OutlineInputBorder(),
              hintText: 'e.g., 0',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientAddressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
              hintText: 'e.g., Cond Estancia...',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientAddress2Controller,
            decoration: const InputDecoration(
              labelText: 'Address Line 2',
              border: OutlineInputBorder(),
              hintText: 'e.g., Quadra 5...',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientAccountTypeController,
            decoration: const InputDecoration(
              labelText: 'Account Type',
              border: OutlineInputBorder(),
              hintText: 'e.g., individual',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientZipCodeController,
            decoration: const InputDecoration(
              labelText: 'Zipcode',
              border: OutlineInputBorder(),
              hintText: 'e.g., 71680389',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientStateIdController,
            decoration: const InputDecoration(
              labelText: 'State ID',
              border: OutlineInputBorder(),
              hintText: 'e.g., 509',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.recipientCountryIdController,
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