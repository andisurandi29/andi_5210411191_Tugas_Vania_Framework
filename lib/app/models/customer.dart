// ignore_for_file: non_constant_identifier_names

import 'package:vania/vania.dart';

class Customer extends Model {
  String? cust_id;
  String? cust_name;
  String? cust_address;
  String? cust_city;
  String? cust_state;
  String? cust_zip;
  String? cust_country;
  String? cust_telp;

  Customer({
    this.cust_id,
    this.cust_name,
    this.cust_address,
    this.cust_city,
    this.cust_state,
    this.cust_zip,
    this.cust_country,
    this.cust_telp,
  }) {
    super.table('customers');
  }

  // Konversi dari JSON ke objek Customer
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      cust_id: json['cust_id'],
      cust_name: json['cust_name'],
      cust_address: json['cust_address'],
      cust_city: json['cust_city'],
      cust_state: json['cust_state'],
      cust_zip: json['cust_zip'],
      cust_country: json['cust_country'],
      cust_telp: json['cust_telp'],
    );
  }

  // Konversi dari objek Customer ke JSON
  Map<String, dynamic> toJson() {
    return {
      'cust_id': cust_id,
      'cust_name': cust_name,
      'cust_address': cust_address,
      'cust_city': cust_city,
      'cust_state': cust_state,
      'cust_zip': cust_zip,
      'cust_country': cust_country,
      'cust_telp': cust_telp,
    };
  }
}
