class CountryState {
  final int id;
  final String code;
  final String name;

  CountryState({required this.id, required this.name,required this.code});

  factory CountryState.fromJson(Map<String, dynamic> json) {
    return CountryState(
      id: json['id'] ?? -1,
      name: json['name'] ?? 'Unknown State',
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
