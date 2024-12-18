// ignore_for_file: implementation_imports

import 'package:vania/vania.dart';
import '../../models/customer.dart';
import 'package:vania/src/exception/validation_exception.dart';

class CustomerController extends Controller {
  // Mendapatkan semua data customer
  Future<Response> index(Request request) async {
    try {
      final customers = await Customer().query().get();
      return Response.json({
        'success': true,
        'data': customers.map((json) => Customer.fromJson(json)).toList(),
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data customer: $e',
      });
    }
  }

  // Mendapatkan data customer berdasarkan ID
  Future<Response> show(String id) async {
    try {
      print('Searching for Customer ID: $id'); // Tambahkan log untuk debugging
      final result = await Customer()
          .query()
          .whereRaw('LOWER(cust_id) = ?', [id.toLowerCase()]).first();
      print('RESULT SHOW : $result');
      // ignore: unnecessary_null_comparison
      final customer = result != null ? Customer.fromJson(result) : null;

      if (customer == null) {
        return Response.json({
          'success': false,
          'message': 'Customer tidak ditemukan',
        });
      }
      return Response.json({
        'success': true,
        'data': customer,
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data customer: $e',
      });
    }
  }

  // Menambahkan data customer baru
  Future<Response> store(Request request) async {
    try {
      request.validate({
        'cust_id': 'required',
        'cust_name': 'required',
        'cust_address': 'required',
        'cust_city': 'required',
        'cust_state': 'required',
        'cust_zip': 'required',
        'cust_country': 'required',
        'cust_telp': 'required',
      }, {
        'cust_id.required': 'ID customer tidak boleh kosong',
        'cust_name.required': 'Nama customer tidak boleh kosong',
        'cust_address.required': 'Alamat customer tidak boleh kosong',
        'cust_city.required': 'Kota customer tidak boleh kosong',
        'cust_state.required': 'Negara bagian customer tidak boleh kosong',
        'cust_zip.required': 'Kode pos customer tidak boleh kosong',
        'cust_country.required': 'Negara customer tidak boleh kosong',
        'cust_telp.required': 'Nomor telepon customer tidak boleh kosong',
      });

      final requestData = request.input();
    
      await Customer().query().insert(requestData);
      
      return Response.json({
        'success': true,
        'message': 'Customer berhasil ditambahkan',
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
          'message': 'Terjadi kesalahan saat menambahkan customer: $e',
        }, 500);
      }
    }
  }

  // Memperbarui data customer
  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'cust_name': 'required',
        'cust_address': 'required',
        'cust_city': 'required',
        'cust_state': 'required',
        'cust_zip': 'required',
        'cust_country': 'required',
        'cust_telp': 'required',
      }, {
        'cust_name.required': 'Nama customer tidak boleh kosong',
        'cust_address.required': 'Alamat customer tidak boleh kosong',
        'cust_city.required': 'Kota customer tidak boleh kosong',
        'cust_state.required': 'Negara bagian customer tidak boleh kosong',
        'cust_zip.required': 'Kode pos customer tidak boleh kosong',
        'cust_country.required': 'Negara customer tidak boleh kosong',
        'cust_telp.required': 'Nomor telepon customer tidak boleh kosong',
      });

      final requestData = request.input();
      final result = await Customer()
          .query()
          .whereRaw('LOWER(cust_id) = ?', [id.toLowerCase()]).first();
      final customer = result != null ? Customer.fromJson(result) : null;
      if (customer == null) {
        return Response.json({
          'success': false,
          'message': 'Customer tidak ditemukan',
        });
      }
      await Customer()
          .query()
          .whereRaw('LOWER(cust_id) = ?', [id.toLowerCase()]).update({
        'cust_name': requestData['cust_name'],
        'cust_address': requestData['cust_address'],
        'cust_city': requestData['cust_city'],
        'cust_state': requestData['cust_state'],
        'cust_zip': requestData['cust_zip'],
        'cust_country': requestData['cust_country'],
        'cust_telp': requestData['cust_telp'],
      });

      return Response.json({
        'success': true,
        'message': 'Customer berhasil diperbarui',
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
          'message': 'Terjadi kesalahan saat memperbarui customer: $e',
        }, 500);
      }
    }
  }

  // Menghapus data customer
  Future<Response> destroy(String id) async {
    try {
      final result = await Customer()
          .query()
          .whereRaw('LOWER(cust_id) = ?', [id.toLowerCase()]).first();
      final customer = result != null ? Customer.fromJson(result) : null;
      if (customer == null) {
        return Response.json({
          'success': false,
          'message': 'Customer tidak ditemukan',
        });
      }
      print('Deleting Customer ID: $id'); // Tambahkan log untuk debugging
      await Customer()
          .query()
          .whereRaw('LOWER(cust_id) = ?', [id.toLowerCase()]).delete();
      print('Customer ID: $id deleted'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Customer berhasil dihapus',
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal menghapus customer: $e',
      });
    }
  }
}
