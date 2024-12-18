import 'package:vania/vania.dart';

class CreateOrdersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    // Membuat tabel 'products'
    await createTableNotExists('orders', () {
      integer('order_num', increment: true); // Primary Key
      date('order_date');
      string('cust_id');
      timeStamps();

      primary('order_num');
      // Definisi Foreign Key untuk vend_id
      foreign('cust_id', 'customers', 'cust_id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
