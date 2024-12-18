import 'package:vania/vania.dart';
import '../../models/vendor.dart';
import 'package:vania/src/exception/validation_exception.dart';

class VendorController extends Controller {
  // Mendapatkan semua data vendor
  Future<Response> index(Request request) async {
    try {
      final vendors = await Vendor().query().get();
      return Response.json({
        'success': true,
        'data': vendors.map((json) => Vendor.fromJson(json)).toList(),
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data vendors: $e',
      });
    }
  }

  // Mendapatkan data vendor berdasarkan ID
  Future<Response> show(Request request, String id) async {
    try {
      print('Searching for Vendor ID: $id'); // Tambahkan log untuk debugging
      final result = await Vendor()
          .query()
          .whereRaw('LOWER(vend_id) = ?', [id.toLowerCase()]).first();
      print('RESULT SHOW : $result');
      final vendor = result != null ? Vendor.fromJson(result) : null;

      if (vendor == null) {
        return Response.json({
          'success': false,
          'message': 'Vendor tidak ditemukan',
        });
      }
      return Response.json({
        'success': true,
        'data': vendor,
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data vendor: $e',
      });
    }
  }

  // Menambahkan data vendor baru
  Future<Response> store(Request request) async {
    try {
      request.validate({
        'vend_id': 'required',
        'vend_name': 'required',
        'vend_address': 'required',
        'vend_kota': 'required',
        'vend_state': 'required',
        'vend_zip': 'required',
        'vend_country': 'required',
      }, {
        'vend_id.required': 'ID vendor tidak boleh kosong',
        'vend_name.required': 'Nama vendor tidak boleh kosong',
        'vend_address.required': 'Alamat vendor tidak boleh kosong',
        'vend_kota.required': 'Kota vendor tidak boleh kosong',
        'vend_state.required': 'Negara bagian vendor tidak boleh kosong',
        'vend_zip.required': 'Kode pos vendor tidak boleh kosong',
        'vend_country.required': 'Negara vendor tidak boleh kosong',
      });

      final requestData = request.input();
      print('Request Data: $requestData'); // Tambahkan log untuk debugging
      await Vendor().query().insert(requestData);
      print(
          'Vendor ID: ${requestData['vend_id']}'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Vendor berhasil ditambahkan',
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
          'message': 'Terjadi kesalahan saat menambahkan vendor: $e',
        }, 500);
      }
    }
  }

  // Memperbarui data vendor
  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'vend_name': 'required',
        'vend_address': 'required',
        'vend_kota': 'required',
        'vend_state': 'required',
        'vend_zip': 'required',
        'vend_country': 'required',
      }, {
        'vend_id.required': 'ID vendor tidak boleh kosong',
        'vend_name.required': 'Nama vendor tidak boleh kosong',
        'vend_address.required': 'Alamat vendor tidak boleh kosong',
        'vend_kota.required': 'Kota vendor tidak boleh kosong',
        'vend_state.required': 'Negara bagian vendor tidak boleh kosong',
        'vend_zip.required': 'Kode pos vendor tidak boleh kosong',
        'vend_country.required': 'Negara vendor tidak boleh kosong',
      });

      final requestData = request.input();
      print('Searching for Vendor ID: $id'); // Tambahkan log untuk debugging
      final result = await Vendor()
          .query()
          .whereRaw('LOWER(vend_id) = ?', [id.toLowerCase()]).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final vendor = result != null ? Vendor.fromJson(result) : null;
      if (vendor == null) {
        return Response.json({
          'success': false,
          'message': 'Vendor tidak ditemukan',
        });
      }
      await Vendor()
          .query()
          .whereRaw('LOWER(vend_id) = ?', [id.toLowerCase()]).update({
        'vend_name': requestData['vend_name'],
        'vend_address': requestData['vend_address'],
        'vend_kota': requestData['vend_kota'],
        'vend_state': requestData['vend_state'],
        'vend_zip': requestData['vend_zip'],
        'vend_country': requestData['vend_country'],
     
      });

      return Response.json({
        'success': true,
        'message': 'Vendor berhasil diperbarui',
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
          'message': 'Terjadi kesalahan saat memperbarui vendor: $e',
        }, 500);
      }
    }
  }

  // Menghapus data vendor
  Future<Response> destroy(Request request, String id) async {
    try {
      print('Searching for Vendor ID: $id'); // Tambahkan log untuk debugging
      final result = await Vendor()
          .query()
          .whereRaw('LOWER(vend_id) = ?', [id.toLowerCase()]).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final vendor = result != null ? Vendor.fromJson(result) : null;
      if (vendor == null) {
        return Response.json({
          'success': false,
          'message': 'Vendor tidak ditemukan',
        });
      }
      print('Deleting Vendor ID: $id'); // Tambahkan log untuk debugging
      await Vendor()
          .query()
          .whereRaw('LOWER(vend_id) = ?', [id.toLowerCase()]).delete();
      print('Vendor ID: $id deleted'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'Vendor berhasil dihapus',
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal menghapus vendor: $e',
      });
    }
  }
}
