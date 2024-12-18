import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('product', () {
      string('prod_id', length: 5, unique: true);
      string('vend_id'); // Vendor ID (Foreign Key)
      string('prod_name', length: 25); // Nama produk
      integer('prod_price'); // Harga produk
      text('prod_desc'); // Deskripsi produk
      timeStamps(); // Kolom created_at dan updated_at

      primary('prod_id');
      foreign('vend_id', 'vendors', 'vend_id');
      
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('product');
  }
}
