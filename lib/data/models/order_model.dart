import 'dart:developer';

import 'package:home_delivery_br/data/models/ProductModel.dart';
import 'package:home_delivery_br/data/models/RecipientModel.dart';
import 'package:home_delivery_br/data/models/SenderModel.dart';
import 'package:home_delivery_br/data/models/ServiceModel.dart';

class Order {
  final int? id;
  final String title;
  final String description;
  final String status;
  final DateTime? createdAt;
  final String? trackingCode;
  final Service service;
  final String? merchant;
  final String? carrier;
  final String? customerReference;
  final String? measurementUnit;
  final double weight;
  final double? volumetricWeight;
  final double? length;
  final double? width;
  final double? height;
  final DateTime orderDate;
  final String? warehouseNumber;
  final double orderValue;
  final String shippingServiceName;
  final double? shippingValue;
  final int? prohibitedGoods;
  final double total;
  final double discount;
  final double grossTotal;
  final double taxAndDuty;
  final double feeForTaxAndDuty;
  final Sender sender;
  final Recipient recipient;
  final List<Product> products;

  Order({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    this.createdAt,
    required this.trackingCode,
    required this.service,
    this.merchant,
    this.carrier,
    this.customerReference,
    this.measurementUnit,
    required this.weight,
    this.volumetricWeight,
    this.length,
    this.width,
    this.height,
    required this.orderDate,
    required this.sender,
    this.warehouseNumber,
    required this.orderValue,
    required this.shippingServiceName,
    required this.shippingValue,
    required this.prohibitedGoods,
    required this.total,
    required this.discount,
    required this.grossTotal,
    required this.taxAndDuty,
    required this.feeForTaxAndDuty,
    required this.recipient,
    required this.products,
  });
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      title: json['customer_reference'] ?? '', // Use customer_reference as title?
      description: json['shipping_service_name'] ?? '',
      status: json['order_status_string'] ,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      trackingCode: json['tracking_code'],
      service: Service.fromJson(json['service'] ?? {}),
      merchant: json['merchant'],
      carrier: json['carrier'],
      customerReference: json['customer_reference'],
      measurementUnit: json['measurement_unit'],
      weight: double.tryParse(json['weight']?.toString() ?? '0') ?? 0,
      volumetricWeight: json['Volumetric_weight'] != null
          ? double.tryParse(json['Volumetric_weight'].toString())
          : null,
      length: json['length'] != null
          ? double.tryParse(json['length'].toString())
          : null,
      width: json['width'] != null
          ? double.tryParse(json['width'].toString())
          : null,
      height: json['height'] != null
          ? double.tryParse(json['height'].toString())
          : null,
      orderDate: DateTime.parse(json['order_date']), // Ensure this is non-null
      sender: Sender.fromJson(json['sender'] ?? {}),
      warehouseNumber: json['warehouse_number'],
      orderValue: double.tryParse(json['order_value']?.toString() ?? '0') ?? 0,
      shippingServiceName: json['shipping_service_name'] ?? '',
      shippingValue: json['shipping_value']?.toDouble() ?? 0,
      prohibitedGoods: int.tryParse(json['prohibited_goods']?.toString() ?? '0') ?? 0, // Fix: Parse String to int
      total: json['total']?.toDouble() ?? 0,
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0,
      grossTotal: json['gross_total']?.toDouble() ?? 0,
      taxAndDuty: double.tryParse(json['tax_and_duty']?.toString() ?? '0') ?? 0,
      feeForTaxAndDuty: double.tryParse(json['fee_for_tax_and_duty']?.toString() ?? '0') ?? 0,
      recipient: Recipient.fromJson(json['recipient'] ?? {}),
      products: (json['products'] as List<dynamic>? ?? [])
          .map((p) => Product.fromJson(p))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'tracking_code': trackingCode,
      'service': service.toJson(),
      'merchant': merchant,
      'carrier': carrier,
      'customer_reference': customerReference,
      'measurement_unit': measurementUnit,
      'weight': weight,
      'volumetric_weight': volumetricWeight,
      'length': length,
      'width': width,
      'height': height,
      'order_date': orderDate.toIso8601String(),
      'sender': sender.toJson(),
      'warehouse_number': warehouseNumber,
      'order_value': orderValue,
      'shipping_service_name': shippingServiceName,
      'shipping_value': shippingValue,
      'prohibited_goods': prohibitedGoods,
      'total': total,
      'discount': discount,
      'gross_total': grossTotal,
      'tax_and_duty': taxAndDuty,
      'fee_for_tax_and_duty': feeForTaxAndDuty,
      'recipient': recipient.toJson(),
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  Order copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    DateTime? createdAt,
    String? trackingCode,
    Service? service,
    String? merchant,
    String? carrier,
    String? customerReference,
    String? measurementUnit,
    double? weight,
    double? volumetricWeight,
    double? length,
    double? width,
    double? height,
    DateTime? orderDate,
    Sender? sender,
    String? warehouseNumber,
    double? orderValue,
    String? shippingServiceName,
    double? shippingValue,
    int? prohibitedGoods,
    double? total,
    double? discount,
    double? grossTotal,
    double? taxAndDuty,
    double? feeForTaxAndDuty,
    Recipient? recipient,
    List<Product>? products,
  }) {
    return Order(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      trackingCode: trackingCode ?? this.trackingCode,
      service: service ?? this.service,
      merchant: merchant ?? this.merchant,
      carrier: carrier ?? this.carrier,
      customerReference: customerReference ?? this.customerReference,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      weight: weight ?? this.weight,
      volumetricWeight: volumetricWeight ?? this.volumetricWeight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      orderDate: orderDate ?? this.orderDate,
      sender: sender ?? this.sender,
      warehouseNumber: warehouseNumber ?? this.warehouseNumber,
      orderValue: orderValue ?? this.orderValue,
      shippingServiceName: shippingServiceName ?? this.shippingServiceName,
      shippingValue: shippingValue ?? this.shippingValue,
      prohibitedGoods: prohibitedGoods ?? this.prohibitedGoods,
      total: total ?? this.total,
      discount: discount ?? this.discount,
      grossTotal: grossTotal ?? this.grossTotal,
      taxAndDuty: taxAndDuty ?? this.taxAndDuty,
      feeForTaxAndDuty: feeForTaxAndDuty ?? this.feeForTaxAndDuty,
      recipient: recipient ?? this.recipient,
      products: products ?? this.products,
    );
  }
}
