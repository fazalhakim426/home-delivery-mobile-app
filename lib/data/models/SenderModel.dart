import 'package:home_delivery_br/data/models/CountryModel.dart';

import 'CountryStateModel.dart';

class Sender {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? taxId;
  final String? sender_zipcode;
  final String? sender_website;
  final Country? country;
  final CountryState? state;

  Sender({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.taxId,
    this.sender_zipcode,
    this.sender_website,
    this.country,
    this.state,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      firstName: json['sender_first_name'] ?? '',
      lastName: json['sender_last_name'] ?? '',
      email: json['sender_email'] ?? '',
      taxId: json['sender_taxId'] ?? '',
      sender_website: json['sender_website'] ?? '',
      sender_zipcode: json['sender_zipcode'] ?? '',
      state: json['state'] != null ? CountryState.fromJson(json['state']) : null,
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_first_name': firstName ?? '',
      'sender_last_name': lastName ?? '',
      'sender_email': email ?? '',
      'sender_taxId': taxId ?? '',
      'sender_website': sender_website ?? '',
      'sender_zipcode': sender_zipcode ?? '',
      'state': state?.toJson(),  // Will be null if state is null
      'country': country?.toJson(),  // Will be null if country is null
    };
  }

}
