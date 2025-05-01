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
