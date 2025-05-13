class ShCode {
  final int code;
  final String description;

  ShCode({
    required this.code,
    required this.description,
  });

  factory ShCode.fromJson(Map<String, dynamic> json) {
    // Convert code to int (handle both string and int cases)
    final code = json['code'] is String
        ? int.tryParse(json['code']) ?? 0
        : json['code'] as int? ?? 0;

    // Split description and take first part
    final fullDescription = json['description'] as String? ?? 'Unknown ShCode';
    final description = fullDescription.split('-------').first.trim();

    return ShCode(
      code: code,
      description: description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
    };
  }
}
