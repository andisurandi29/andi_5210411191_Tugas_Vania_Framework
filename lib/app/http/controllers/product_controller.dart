import 'package:vania/vania.dart';
import '../../models/product.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {
  // Mendapatkan semua data produk
  Future<Response> index(Request request) async {
    try {
      final products = await Product().query().get();
      return Response.json({
        'success': true,
        'data': products.map((json) => Product.fromJson(json)).toList(),
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data produk: $e',
      });
    }
  }

  // Mendapatkan data produk berdasarkan ID
  Future<Response> show(Request request, String id) async {
    try {
      print('Searching for Product ID: $id'); // Tambahkan log untuk debugging
      final result = await Product()
          .query()
          .whereRaw('LOWER(prod_id) = ?', [id.toLowerCase()]).first();
      print('RESULT SHOW : $result');
      final product = result != null ? Product.fromJson(result) : null;

      if (product == null) {
        return Response.json({
          'success': false,
          'message': 'Produk tidak ditemukan',
        });
      }
      return Response.json({
        'success': true,
        'data': product,
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data produk: $e',
      });
    }
  }

  // Menambahkan data produk baru
  Future<Response> store(Request request) async {
    try {
      request.validate({
        'prod_id': 'required',
        'prod_name': 'required',
        'vend_id': 'required',
        'prod_price': 'required|numeric',
        'prod_desc': 'required',
      }, {
        'prod_id.required': 'ID produk tidak boleh kosong',
        'prod_name.required': 'Nama produk tidak boleh kosong',
        'vend_id.required': 'ID vendor tidak boleh kosong',
        'prod_price.required': 'Harga produk tidak boleh kosong',
        'prod_price.numeric': 'Harga produk harus berupa angka',
        'prod_desc.required': 'Deskripsi produk tidak boleh kosong',
      });

      final requestData = request.input();
      print('Request Data: $requestData'); // Tambahkan log untuk debugging
      await Product().query().insert(requestData);
      print('Product ID: ${requestData['prod_id']}'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Produk berhasil ditambahkan',
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
          'message': 'Terjadi kesalahan saat menambahkan produk: $e',
        }, 500);
      }
    }
  }

  // Memperbarui data produk
  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'prod_name': 'required',
        'vend_id': 'required',
        'prod_price': 'required|numeric',
        'prod_desc': 'required',
      }, {
        'prod_name.required': 'Nama produk tidak boleh kosong',
        'vend_id.required': 'ID vendor tidak boleh kosong',
        'prod_price.required': 'Harga produk tidak boleh kosong',
        'prod_price.numeric': 'Harga produk harus berupa angka',
        'prod_desc.required': 'Deskripsi produk tidak boleh kosong',
      });

      final requestData = request.input();
      print('Searching for Product ID: $id'); // Tambahkan log untuk debugging
      final result = await Product()
          .query()
          .whereRaw('LOWER(prod_id) = ?', [id.toLowerCase()]).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final product = result != null ? Product.fromJson(result) : null;
      if (product == null) {
        return Response.json({
          'success': false,
          'message': 'Produk tidak ditemukan',
        });
      }
      await Product()
          .query()
          .whereRaw('LOWER(prod_id) = ?', [id.toLowerCase()]).update({
        'prod_name': requestData['prod_name'],
        'vend_id': requestData['vend_id'],
        'prod_price': requestData['prod_price'],
        'prod_desc': requestData['prod_desc'],
      });

      return Response.json({
        'success': true,
        'message': 'Produk berhasil diperbarui',
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
          'message': 'Terjadi kesalahan saat memperbarui produk: $e',
        }, 500);
      }
    }
  }

  // Menghapus data produk
  Future<Response> destroy(Request request, String id) async {
    try {
      print('Searching for Product ID: $id'); // Tambahkan log untuk debugging
      final result = await Product()
          .query()
          .whereRaw('LOWER(prod_id) = ?', [id.toLowerCase()]).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final product = result != null ? Product.fromJson(result) : null;
      if (product == null) {
        return Response.json({
          'success': false,
          'message': 'Produk tidak ditemukan',
        });
      }
      print('Deleting Product ID: $id'); // Tambahkan log untuk debugging
      await Product()
          .query()
          .whereRaw('LOWER(prod_id) = ?', [id.toLowerCase()]).delete();
      print('Product ID: $id deleted'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Produk berhasil dihapus',
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal menghapus produk: $e',
      });
    }
  }
}