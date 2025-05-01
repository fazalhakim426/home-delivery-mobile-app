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
