import 'package:vania/vania.dart';

class CreateProductNotesTable extends Migration {
  @override
  Future<void> up() async {
    super.up();

    // Membuat tabel 'productnotes'
    await createTableNotExists('productnotes', () {
      string('note_id', length: 5, unique: true); // Primary Key
      string('prod_id', length: 5); // Kolom ID Produk
      date('note_date'); // Tanggal Catatan
      text('note_text'); // Teks Catatan
      timeStamps(); // Kolom created_at dan updated_at

      // Definisi Foreign Key untuk prod_id
      primary('note_id');
      foreign('prod_id', 'product', 'prod_id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    // Menghapus tabel 'productnotes' jika ada
    await dropIfExists('productnotes');
  }
}
