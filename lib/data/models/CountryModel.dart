class Country {
  final int id;
  final String code;
  final String name;

  Country({required this.id, required this.name,required this.code});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? -1,
      name: json['name'] ?? 'Unknown Country',
      code: json['code'] ?? 'Unknown Code',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}
