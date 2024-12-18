import 'package:vania/vania.dart';

class OrderItem extends Model {
  int? order_item;
  int? order_num; // Foreign key
  String? prod_id; // Foreign key
  int? quantity;
  int? size;

  OrderItem({
    this.order_item,
    this.order_num,
    this.prod_id,
    this.quantity,
    this.size,
  }) {
    super.table('orderitems');
  }

  // Konversi dari JSON ke objek OrderItem
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      order_item: json['order_item'],
      order_num: json['order_num'],
      prod_id: json['prod_id'],
      quantity: json['quantity'],
      size: json['size'],
    );
  }

  // Konversi dari objek OrderItem ke JSON
  Map<String, dynamic> toJson() {
    return {
      'order_item': order_item,
      'order_num': order_num,
      'prod_id': prod_id,
      'quantity': quantity,
      'size': size,
    };
  }
}
