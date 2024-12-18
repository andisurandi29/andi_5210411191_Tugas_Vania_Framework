import 'package:vania/vania.dart';
import '../../models/order.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderController extends Controller {
  // Mendapatkan semua data order
  Future<Response> index(Request request) async {
    try {
      final orders = await Order().query().get();
      return Response.json({
        'success': true,
        'data': orders.map((json) => Order.fromJson(json)).toList(),
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data order: $e',
      });
    }
  }

  // Mendapatkan data order berdasarkan ID
  Future<Response> show(Request request, int id) async {
    try {
      print('Searching for Order ID: $id'); // Tambahkan log untuk debugging
      final result = await Order().query().whereRaw('LOWER(order_num) = ?', [id]).first();
      print('RESULT SHOW : $result');
      final order = result != null ? Order.fromJson(result) : null;

      if (order == null) {
        return Response.json({
          'success': false,
          'message': 'Order tidak ditemukan',
        });
      }
      return Response.json({
        'success': true,
        'data': order,
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data order: $e',
      });
    }
  }

  // Menambahkan data order baru
  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_num': 'required',
        'order_date': 'required|date',
        'cust_id': 'required',
      }, {
        'order_num.required': 'Nomor order tidak boleh kosong',
        'order_date.required': 'Tanggal order tidak boleh kosong',
        'order_date.date': 'Tanggal order harus berupa tanggal yang valid',
        'cust_id.required': 'ID customer tidak boleh kosong',
      });

      final requestData = request.input();
      print('Request Data: $requestData'); // Tambahkan log untuk debugging
      await Order().query().insert(requestData);
      print('Order Number: ${requestData['order_num']}'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Order berhasil ditambahkan',
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
          'message': 'Terjadi kesalahan saat menambahkan order: $e',
        }, 500);
      }
    }
  }

  // Memperbarui data order
  Future<Response> update(Request request, int id) async {
    try {
      request.validate({
        'order_date': 'required|date',
        'cust_id': 'required',
      }, {
        'order_date.required': 'Tanggal order tidak boleh kosong',
        'order_date.date': 'Tanggal order harus berupa tanggal yang valid',
        'cust_id.required': 'ID customer tidak boleh kosong',
      });

      final requestData = request.input();
      print('Searching for Order ID: $id'); // Tambahkan log untuk debugging
      final result = await Order().query().whereRaw('LOWER(order_num) = ?', [id]).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final order = result != null ? Order.fromJson(result) : null;
      if (order == null) {
        return Response.json({
          'success': false,
          'message': 'Order tidak ditemukan',
        });
      }
      await Order().query().whereRaw('LOWER(order_num) = ?', [id]).update({
        'order_date': requestData['order_date'],
        'cust_id': requestData['cust_id'],
      });

      return Response.json({
        'success': true,
        'message': 'Order berhasil diperbarui',
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
          'message': 'Terjadi kesalahan saat memperbarui order: $e',
        }, 500);
      }
    }
  }

  // Menghapus data order
  Future<Response> destroy(Request request, int id) async {
    try {
      print('Searching for Order ID: $id'); // Tambahkan log untuk debugging
      final result = await Order().query().whereRaw('LOWER(order_num) = ?', [id]).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final order = result != null ? Order.fromJson(result) : null;
      if (order == null) {
        return Response.json({
          'success': false,
          'message': 'Order tidak ditemukan',
        });
      }
      print('Deleting Order ID: $id'); // Tambahkan log untuk debugging
      await Order().query().whereRaw('LOWER(order_num) = ?', [id]).delete();
      print('Order ID: $id deleted'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Order berhasil dihapus',
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal menghapus order: $e',
      });
    }
  }
}