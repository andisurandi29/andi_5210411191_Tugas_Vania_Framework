import 'package:vania/vania.dart';
import '../../models/product_note.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductNoteController extends Controller {
  // Mendapatkan semua data product note
  Future<Response> index(Request request) async {
    try {
      final productNotes = await ProductNote().query().get();
      return Response.json({
        'success': true,
        'data': productNotes.map((json) => ProductNote.fromJson(json)).toList(),
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data product note: $e',
      });
    }
  }

  // Mendapatkan data product note berdasarkan ID
  Future<Response> show(Request request, String id) async {
    try {
      print(
          'Searching for Product Note ID: $id'); // Tambahkan log untuk debugging
      final result = await ProductNote().query().where('note_id', id).first();
      print('RESULT SHOW : $result');
      final productNote = result != null ? ProductNote.fromJson(result) : null;

      if (productNote == null) {
        return Response.json({
          'success': false,
          'message': 'Product note tidak ditemukan',
        });
      }
      return Response.json({
        'success': true,
        'data': productNote,
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data product note: $e',
      });
    }
  }

  // Menambahkan data product note baru
  Future<Response> store(Request request) async {
    try {
      request.validate({
        'note_id': 'required',
        'prod_id': 'required',
        'note_date': 'required|date',
        'note_text': 'required',
      }, {
        'note_id.required': 'ID note tidak boleh kosong',
        'prod_id.required': 'ID produk tidak boleh kosong',
        'note_date.required': 'Tanggal note tidak boleh kosong',
        'note_date.date': 'Tanggal note harus berupa tanggal yang valid',
        'note_text.required': 'Teks note tidak boleh kosong',
      });

      final requestData = request.input();
      print('Request Data: $requestData'); // Tambahkan log untuk debugging
      await ProductNote().query().insert(requestData);
      print(
          'Note ID: ${requestData['note_id']}'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Product note berhasil ditambahkan',
        'data': requestData,
      }, 201);
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      if (e is ValidationException) {
        final errorMessage = e.message;
        return Response.json({
          'success': false,
          'message': errorMessage,
        }, 400);
      } else {
        return Response.json({
          'success': false,
          'message': 'Terjadi kesalahan saat menambahkan product note: $e',
        }, 500);
      }
    }
  }

  // Memperbarui data product note
  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'prod_id': 'required',
        'note_date': 'required|date',
        'note_text': 'required',
      }, {
        'prod_id.required': 'ID produk tidak boleh kosong',
        'note_date.required': 'Tanggal note tidak boleh kosong',
        'note_date.date': 'Tanggal note harus berupa tanggal yang valid',
        'note_text.required': 'Teks note tidak boleh kosong',
      });

      final requestData = request.input();
      print(
          'Searching for Product Note ID: $id'); // Tambahkan log untuk debugging
      final result = await ProductNote().query().where('note_id', id).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final productNote = result != null ? ProductNote.fromJson(result) : null;
      if (productNote == null) {
        return Response.json({
          'success': false,
          'message': 'Product note tidak ditemukan',
        });
      }
      await ProductNote().query().where('note_id', id).update({
        'prod_id': requestData['prod_id'],
        'note_date': requestData['note_date'],
        'note_text': requestData['note_text'],
      });

      return Response.json({
        'success': true,
        'message': 'Product note berhasil diperbarui',
        'data': requestData,
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      if (e is ValidationException) {
        final errorMessage = e.message;
        return Response.json({
          'success': false,
          'message': errorMessage,
        }, 400);
      } else {
        return Response.json({
          'success': false,
          'message': 'Terjadi kesalahan saat memperbarui product note: $e',
        }, 500);
      }
    }
  }

  // Menghapus data product note
  Future<Response> destroy(Request request, String id) async {
    try {
      print(
          'Searching for Product Note ID: $id'); // Tambahkan log untuk debugging
      final result = await ProductNote().query().where('note_id', id).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final productNote = result != null ? ProductNote.fromJson(result) : null;
      if (productNote == null) {
        return Response.json({
          'success': false,
          'message': 'Product note tidak ditemukan',
        });
      }
      print('Deleting Product Note ID: $id'); // Tambahkan log untuk debugging
      await ProductNote().query().where('note_id', id).delete();
      print('Product Note ID: $id deleted'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Product note berhasil dihapus',
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal menghapus product note: $e',
      });
    }
  }
}
