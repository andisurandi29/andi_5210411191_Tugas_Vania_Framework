import 'package:vania/vania.dart';

class Vendor extends Model {
  String? vend_id;
  String? vend_name;
  String? vend_address;
  String? vend_kota;
  String? vend_state;
  String? vend_zip;
  String? vend_country;

  Vendor({
    this.vend_id,
    this.vend_name,
    this.vend_address,
    this.vend_kota,
    this.vend_state,
    this.vend_zip,
    this.vend_country,
  }) {
    super.table('vendors');
  }

  // Konversi dari JSON ke objek Vendor
  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vend_id: json['vend_id'],
      vend_name: json['vend_name'],
      vend_address: json['vend_address'],
      vend_kota: json['vend_kota'],
      vend_state: json['vend_state'],
      vend_zip: json['vend_zip'],
      vend_country: json['vend_country'],
    );
  }

  // Konversi dari objek Vendor ke JSON
  Map<String, dynamic> toJson() {
    return {
      'vend_id': vend_id,
      'vend_name': vend_name,
      'vend_address': vend_address,
      'vend_kota': vend_kota,
      'vend_state': vend_state,
      'vend_zip': vend_zip,
      'vend_country': vend_country,
    };
  }
}
