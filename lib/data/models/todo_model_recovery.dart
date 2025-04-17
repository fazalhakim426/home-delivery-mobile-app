class Todo {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? createdAt;
  final String trackingCode;
  final String serviceName;
  final double weight;
  final DateTime orderDate;
  final double orderValue;
  final String recipientName;
  final String recipientCountry;

  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.createdAt,
    required this.trackingCode,
    required this.serviceName,
    required this.weight,
    required this.orderDate,
    required this.orderValue,
    required this.recipientName,
    required this.recipientCountry,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      trackingCode: json['trackingCode'] ?? 'TRK${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      serviceName: json['serviceName'] ?? 'Express Shipping',
      weight: json['weight']?.toDouble() ?? 1.5,
      orderDate: json['orderDate'] != null ? DateTime.parse(json['orderDate']) : DateTime.now(),
      orderValue: json['orderValue']?.toDouble() ?? 49.99,
      recipientName: json['recipientName'] ?? 'John Doe',
      recipientCountry: json['recipientCountry'] ?? 'US',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
      'trackingCode': trackingCode,
      'serviceName': serviceName,
      'weight': weight,
      'orderDate': orderDate.toIso8601String(),
      'orderValue': orderValue,
      'recipientName': recipientName,
      'recipientCountry': recipientCountry,
    };
  }

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    String? trackingCode,
    String? serviceName,
    double? weight,
    DateTime? orderDate,
    double? orderValue,
    String? recipientName,
    String? recipientCountry,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      trackingCode: trackingCode ?? this.trackingCode,
      serviceName: serviceName ?? this.serviceName,
      weight: weight ?? this.weight,
      orderDate: orderDate ?? this.orderDate,
      orderValue: orderValue ?? this.orderValue,
      recipientName: recipientName ?? this.recipientName,
      recipientCountry: recipientCountry ?? this.recipientCountry,
    );
  }

  // Helper method to create dummy data
  static Todo dummy() {
    final now = DateTime.now();
    final randomCode = 'TRK${now.millisecondsSinceEpoch.toString().substring(5)}';
    const services = ['Express Shipping', 'Standard Delivery', 'International Priority'];
    const countries = ['US', 'UK', 'CA', 'AU', 'BR', 'DE', 'FR'];

    return Todo(
      id: 1,
      title: 'Sample Order',
      description: 'This is a sample order description',
      isCompleted: false,
      createdAt: now,
      trackingCode: randomCode,
      serviceName: services[now.second % services.length],
      weight: 0.5 + (now.second % 10) * 0.3, // Random weight between 0.5-3.2 kg
      orderDate: now.subtract(Duration(days: now.second % 30)), // Random date in last 30 days
      orderValue: 10.0 + (now.second % 90) * 0.5, // Random value between $10-$55
      recipientName: 'Customer ${now.second % 100}',
      recipientCountry: countries[now.second % countries.length],
    );
  }
}