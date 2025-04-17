class Todo {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? createdAt;
  final String trackingCode;
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
  final double shippingValue;
  final int prohibitedGoods;
  final double total;
  final double discount;
  final double grossTotal;
  final double taxAndDuty;
  final double feeForTaxAndDuty;
  final Recipient recipient;
  final List<Product> products;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
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

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      isCompleted: json['is_shipped'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      trackingCode: json['tracking_code'] ?? 'N/A',
      service: Service.fromJson(json['service'] ?? {}),
      merchant: json['merchant'],
      carrier: json['carrier'],
      customerReference: json['customer_reference'],
      measurementUnit: json['measurement_unit'],
      weight: (json['weight'] ?? 0).toDouble(),
      volumetricWeight: (json['Volumetric_weight'] ?? 0).toDouble(),
      length: (json['length'] ?? 0).toDouble(),
      width: (json['width'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      orderDate: DateTime.parse(json['order_date']),
      sender: Sender.fromJson(json['sender'] ?? {}),
      warehouseNumber: json['warehouse_number'],
      orderValue: (json['order_value'] ?? 0).toDouble(),
      shippingServiceName: json['shipping_service_name'] ?? 'Unknown Service',
      shippingValue: (json['shipping_value'] ?? 0).toDouble(),
      prohibitedGoods: json['prohibited_goods'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      grossTotal: (json['gross_total'] ?? 0).toDouble(),
      taxAndDuty: (json['tax_and_duty'] ?? 0).toDouble(),
      feeForTaxAndDuty: (json['fee_for_tax_and_duty'] ?? 0).toDouble(),
      recipient: Recipient.fromJson(json['recipient'] ?? {}),
      products: (json['products'] as List?)
          ?.map((product) => Product.fromJson(product))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
      'tracking_code': trackingCode,
      'service': service.toJson(),
      'merchant': merchant,
      'carrier': carrier,
      'customer_reference': customerReference,
      'measurement_unit': measurementUnit,
      'weight': weight,
      'Volumetric_weight': volumetricWeight,
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

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
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
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
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
  final String stateIsoCode;
  final String countryIsoCode;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String city;
  final String streetNo;
  final String address;
  final String address2;
  final String accountType;
  final String taxId;
  final String zipcode;

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
  final String firstName;
  final String lastName;
  final String email;
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
  final String description;
  final String? madeIn;
  final int quantity;
  final double value;
  final int isBattery;
  final int isPerfume;

  Product({
    required this.shCode,
    required this.description,
    this.madeIn,
    required this.quantity,
    required this.value,
    required this.isBattery,
    required this.isPerfume,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      shCode: json['sh_code'] ?? 0,
      description: json['description'] ?? '',
      madeIn: json['made_in'],
      quantity: json['quantity'] ?? 0,
      value: (json['value'] ?? 0).toDouble(),
      isBattery: json['is_battery'] ?? 0,
      isPerfume: json['is_perfume'] ?? 0,
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
    };
  }
}