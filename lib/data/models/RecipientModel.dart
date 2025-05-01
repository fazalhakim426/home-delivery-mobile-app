
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

