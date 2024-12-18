import 'package:vania/vania.dart';

class CreateVendorsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('vendors', () {
      string('vend_id', length: 5, unique: true);
      string('vend_name', length: 50);
      text('vend_address');
      text('vend_kota');
      string('vend_zip', length: 5);
      string('vend_state', length: 15);
      string('vend_country', length: 25);
      timeStamps();

      primary('vend_id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('vendors');
  }
}
