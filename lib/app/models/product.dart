import 'package:vania/vania.dart';

class Product extends Model {
  String? prod_id;
  String? vend_id; // Foreign key
  String? prod_name;
  double? prod_price;
  String? prod_desc;

  Product({
    this.prod_id,
    this.vend_id,
    this.prod_name,
    this.prod_price,
    this.prod_desc,
  }) {
    super.table('product');
  }

  // Konversi dari JSON ke objek Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      prod_id: json['prod_id'],
      vend_id: json['vend_id'],
      prod_name: json['prod_name'],
      prod_price: json['prod_price'].toDouble(),
      prod_desc: json['prod_desc'],
    );
  }

  // Konversi dari objek Product ke JSON
  Map<String, dynamic> toJson() {
    return {
      'prod_id': prod_id,
      'vend_id': vend_id,
      'prod_name': prod_name,
      'prod_price': prod_price,
      'prod_desc': prod_desc,
    };
  }
}
