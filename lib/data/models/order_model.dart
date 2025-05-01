class Order {
  final int? id;
  final String title;
  final String description;
  final bool isShipped;
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
  final Sender sender;
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
  final Recipient recipient;
  final List<Product> products;

  Order({
    this.id,
    required this.title,
    required this.description,
    required this.isShipped,
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
  // factory Order.fromJson(Map<String, dynamic> json) {
  //   return Order(
  //     id: json['id'],
  //     title: json['title'] ?? '',
  //     description: json['description'] ?? '',
  //     isShipped: json['is_shipped'] ?? false,
  //     createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
  //     trackingCode: json['tracking_code'] ?? '',
  //     service: Service.fromJson(json['service'] ?? {}),
  //     merchant: json['merchant'],
  //     carrier: json['carrier'],
  //     customerReference: json['customer_reference'],
  //     measurementUnit: json['measurement_unit'],
  //     weight: double.tryParse(json['weight'].toString()) ?? 0,
  //     volumetricWeight: json['volumetric_weight'] != null ? double.tryParse(json['volumetric_weight'].toString()) : null,
  //     length: json['length'] != null ? double.tryParse(json['length'].toString()) : null,
  //     width: json['width'] != null ? double.tryParse(json['width'].toString()) : null,
  //     height: json['height'] != null ? double.tryParse(json['height'].toString()) : null,
  //     orderDate: json['order_date'] != null ? DateTime.tryParse(json['order_date']) ?? DateTime.now() : DateTime.now(),
  //     sender: Sender.fromJson(json['sender'] ?? {}),
  //     warehouseNumber: json['warehouse_number'],
  //     orderValue: double.tryParse(json['order_value'].toString()) ?? 0,
  //     shippingServiceName: json['shipping_service_name'] ?? '',
  //     shippingValue: double.tryParse(json['shipping_value'].toString()) ?? 0,
  //     prohibitedGoods: 0,
  //     total: double.tryParse(json['total'].toString()) ?? 0,
  //     discount: double.tryParse(json['discount'].toString()) ?? 0,
  //     grossTotal: double.tryParse(json['gross_total'].toString()) ?? 0,
  //     taxAndDuty: double.tryParse(json['tax_and_duty'].toString()) ?? 0,
  //     feeForTaxAndDuty: double.tryParse(json['fee_for_tax_and_duty'].toString()) ?? 0,
  //     recipient: Recipient.fromJson(json['recipient'] ?? {}),
  //     products: (json['products'] as List<dynamic>? ?? []).map((p) => Product.fromJson(p)).toList(),
  //   );
  // }


  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      title: json['customer_reference'] ?? '', // Use customer_reference as title?
      description: json['shipping_service_name'] ?? '', // Use shipping_service_name as description?
      isShipped: json['is_shipped'] ?? false,
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
      'isShipped': isShipped,
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
    bool? isShipped,
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
      isShipped: isShipped ?? this.isShipped,
      createdAt: createdAt ?? this.createdAt,
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
class ShCode{
  final int code;
  final String description ;
  ShCode({
    required this.code,required this.description
});
  factory ShCode.fromJson(Map<String, dynamic> json) {
    return ShCode(
      code: json['code'] ?? 0,
      description: json['description'] ?? 'Unknown ShCode',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
    };
  }
}
class Service {
  final int id;
  final String name;

  Service({required this.id, required this.name});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Service',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Recipient {
  final String? stateIsoCode;
  final String countryIsoCode;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? city;
  final String? streetNo;
  final String address;
  final String? address2;
  final String? accountType;
  final String? taxId;
  final String? zipcode;

  Recipient({
    required this.stateIsoCode,
    required this.countryIsoCode,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.streetNo,
    required this.address,
    required this.address2,
    required this.accountType,
    required this.taxId,
    required this.zipcode,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      stateIsoCode: json['state_iso_code'] ?? '',
      countryIsoCode: json['country_iso_code'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      streetNo: json['street_no'] ?? '',
      address: json['address'] ?? '',
      address2: json['address2'] ?? '',
      accountType: json['account_type'] ?? '',
      taxId: json['tax_id'] ?? '',
      zipcode: json['zipcode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state_iso_code': stateIsoCode,
      'country_iso_code': countryIsoCode,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'city': city,
      'street_no': streetNo,
      'address': address,
      'address2': address2,
      'account_type': accountType,
      'tax_id': taxId,
      'zipcode': zipcode,
    };
  }
}

class Sender {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? taxId;

  Sender({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.taxId,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      firstName: json['sender_first_name'] ?? '',
      lastName: json['sender_last_name'] ?? '',
      email: json['sender_email'] ?? '',
      taxId: json['sender_taxId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_first_name': firstName,
      'sender_last_name': lastName,
      'sender_email': email,
      'sender_taxId': taxId,
    };
  }
}
class Product {
  final int shCode;
  final String? description;
  final String? madeIn;
  final int quantity;
  final double value;
  final int isBattery;
  final int isPerfume;
  final int isFlameable;

  Product({
    required this.shCode,
    required this.description,
    this.madeIn,
    required this.quantity,
    required this.value,
    required this.isBattery,
    required this.isPerfume,
    required this.isFlameable,

  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      shCode: int.tryParse(json['sh_code']?.toString() ?? '0') ?? 0, // Fix: Parse String to int
      description: json['description'] ?? '',
      madeIn: json['made_in'],
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      value: double.tryParse(json['value']?.toString() ?? '0') ?? 0,
      isBattery: int.tryParse(json['is_battery']?.toString() ?? '0') ?? 0,
      isPerfume: int.tryParse(json['is_perfume']?.toString() ?? '0') ?? 0,
      isFlameable: int.tryParse(json['is_flameable']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sh_code': shCode,
      'description': description,
      'made_in': madeIn,
      'quantity': quantity,
      'value': value,
      'is_battery': isBattery,
      'is_perfume': isPerfume,
      'is_flameable':isFlameable
    };
  }
}
