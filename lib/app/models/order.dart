import 'package:vania/vania.dart';

class Order extends Model {
  int? order_num;
  DateTime? order_date;
  String? cust_id;

  Order({
    this.order_num,
    this.order_date,
    this.cust_id,
  }) {
    super.table('orders');
  }

  // Konversi dari JSON ke objek Order
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      order_num: json['order_num'],
      order_date: DateTime.parse(json['order_date']),
      cust_id: json['cust_id'],
    );
  }

  // Konversi dari objek Order ke JSON
  Map<String, dynamic> toJson() {
    return {
      'order_num': order_num,
      'order_date': order_date?.toIso8601String(),
      'cust_id': cust_id,
    };
  }
}
