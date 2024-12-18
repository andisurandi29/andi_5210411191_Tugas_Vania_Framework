import 'package:vania/vania.dart';

class CreateOrderItemsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orderitems', () {
      integer('order_item', increment: true); // Primary Key
      integer('order_num');
      string('prod_id', length: 10);
      integer('quantity');
      integer('size');
      timeStamps();

      // Foreign Key
      primary('order_item');
      foreign('order_num', 'orders', 'order_num');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
