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
