import 'package:vania/vania.dart';
import '../../models/order_item.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderItemController extends Controller {
  // Mendapatkan semua data order item
  Future<Response> index(Request request) async {
    try {
      final orderItems = await OrderItem().query().get();
      return Response.json({
        'success': true,
        'data': orderItems.map((json) => OrderItem.fromJson(json)).toList(),
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data order item: $e',
      });
    }
  }

  // Mendapatkan data order item berdasarkan ID
  Future<Response> show(Request request, int id) async {
    try {
      print(
          'Searching for Order Item ID: $id'); // Tambahkan log untuk debugging
      final result =
          await OrderItem().query().where('order_item', id.toString()).first();
      print('RESULT SHOW : $result');
      final orderItem = result != null ? OrderItem.fromJson(result) : null;

      if (orderItem == null) {
        return Response.json({
          'success': false,
          'message': 'Order item tidak ditemukan',
        });
      }
      return Response.json({
        'success': true,
        'data': orderItem,
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data order item: $e',
      });
    }
  }

  // Menambahkan data order item baru
  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_num': 'required',
        'prod_id': 'required',
        'quantity': 'required|numeric',
        'size': 'required|numeric',
      }, {
        'order_num.required': 'Nomor order tidak boleh kosong',
        'prod_id.required': 'ID produk tidak boleh kosong',
        'quantity.required': 'Kuantitas tidak boleh kosong',
        'quantity.numeric': 'Kuantitas harus berupa angka',
        'size.required': 'Ukuran tidak boleh kosong',
        'size.numeric': 'Ukuran harus berupa angka',
      });

      final requestData = request.input();
      print('Request Data: $requestData'); // Tambahkan log untuk debugging
      await OrderItem().query().insert(requestData);
      print(
          'Order Item ID: ${requestData['order_item']}'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Order item berhasil ditambahkan',
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
          'message': 'Terjadi kesalahan saat menambahkan order item: $e',
        }, 500);
      }
    }
  }

  // Memperbarui data order item
  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'order_num': 'required',
        'prod_id': 'required',
        'quantity': 'required|numeric',
        'size': 'required|numeric',
      }, {
        'order_num.required': 'Nomor order tidak boleh kosong',
        'prod_id.required': 'ID produk tidak boleh kosong',
        'quantity.required': 'Kuantitas tidak boleh kosong',
        'quantity.numeric': 'Kuantitas harus berupa angka',
        'size.required': 'Ukuran tidak boleh kosong',
        'size.numeric': 'Ukuran harus berupa angka',
      });

      final requestData = request.input();
      print(
          'Searching for Order Item ID: $id'); // Tambahkan log untuk debugging
      final result =
          await OrderItem().query().where('order_item', id.toString()).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final orderItem = result != null ? OrderItem.fromJson(result) : null;
      if (orderItem == null) {
        return Response.json({
          'success': false,
          'message': 'Order item tidak ditemukan',
        });
      }
      await OrderItem().query().where('order_item', id.toString()).update({
        'order_num': requestData['order_num'],
        'prod_id': requestData['prod_id'],
        'quantity': requestData['quantity'],
        'size': requestData['size'],
      });

      return Response.json({
        'success': true,
        'message': 'Order item berhasil diperbarui',
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
          'message': 'Terjadi kesalahan saat memperbarui order item: $e',
        }, 500);
      }
    }
  }

  // Menghapus data order item
  Future<Response> destroy(Request request, int id) async {
    try {
      final result = await OrderItem()
          .query()
          .whereRaw('LOWER(order_item) = ?', [id]).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final orderItem = result != null ? OrderItem.fromJson(result) : null;
      if (orderItem == null) {
        return Response.json({
          'success': false,
          'message': 'Order item tidak ditemukan',
        });
      }
      print('Deleting Order Item ID: $id'); // Tambahkan log untuk debugging
      await OrderItem()
          .query()
          .whereRaw('LOWER(order_item) = ?', [id]).delete();
      print('Order Item ID: $id deleted'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Order item berhasil dihapus',
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal menghapus order item: $e',
      });
    }
  }
}
