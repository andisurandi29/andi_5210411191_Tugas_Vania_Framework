import 'package:vania/vania.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method
import '../../models/users.dart';
import 'package:vania/src/exception/validation_exception.dart';

class UserController extends Controller {
  // Mendapatkan semua data user
  Future<Response> index(Request request) async {
    try {
      final users = await User().query().get();
      return Response.json({
        'success': true,
        'data': users.map((json) => User.fromJson(json)).toList(),
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data user: $e',
      });
    }
  }

  // Mendapatkan data user berdasarkan ID
  Future<Response> show(Request request, String id) async {
    try {
      print('Searching for User ID: $id'); // Tambahkan log untuk debugging
      final result = await User()
          .query()
          .whereRaw('LOWER(user_id) = ?', [id.toLowerCase()]).first();
      print('RESULT SHOW : $result');
      final user = result != null ? User.fromJson(result) : null;

      if (user == null) {
        return Response.json({
          'success': false,
          'message': 'User tidak ditemukan',
        });
      }
      return Response.json({
        'success': true,
        'data': user,
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal mengambil data user: $e',
      });
    }
  }

  // Menambahkan data user baru
  Future<Response> store(Request request) async {
    try {
      request.validate({
        'user_id': 'required',
        'user_name': 'required',
        'user_email': 'required|email',
        'user_password': 'required',
      }, {
        'user_id.required': 'ID user tidak boleh kosong',
        'user_name.required': 'Nama user tidak boleh kosong',
        'user_email.required': 'Email user tidak boleh kosong',
        'user_email.email': 'Email user tidak valid',
        'user_password.required': 'Password user tidak boleh kosong',
      });

      final requestData = request.input();
      print('Request Data: $requestData'); // Tambahkan log untuk debugging

      // Hash password
      final password = requestData['user_password'];
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      requestData['user_password'] = hashedPassword;

      await User().query().insert(requestData);
      print(
          'User ID: ${requestData['user_id']}'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'User berhasil ditambahkan',
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
          'message': 'Terjadi kesalahan saat menambahkan user: $e',
        }, 500);
      }
    }
  }

  // Memperbarui data user
  Future<Response> update(Request request, String id) async {
    try {
      request.validate({
        'user_name': 'required',
        'user_email': 'required|email',
        'user_password': 'required',
      }, {
        'user_name.required': 'Nama user tidak boleh kosong',
        'user_email.required': 'Email user tidak boleh kosong',
        'user_email.email': 'Email user tidak valid',
        'user_password.required': 'Password user tidak boleh kosong',
      });

      final requestData = request.input();
      print('Searching for User ID: $id'); // Tambahkan log untuk debugging
      final result = await User()
          .query()
          .whereRaw('LOWER(user_id) = ?', [id.toLowerCase()]).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final user = result != null ? User.fromJson(result) : null;
      if (user == null) {
        return Response.json({
          'success': false,
          'message': 'User tidak ditemukan',
        });
      }

      // Hash password
      final password = requestData['user_password'];
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      requestData['user_password'] = hashedPassword;

      await User()
          .query()
          .whereRaw('LOWER(user_id) = ?', [id.toLowerCase()]).update({
        'user_name': requestData['user_name'],
        'user_email': requestData['user_email'],
        'user_password': requestData['user_password'],
      });

      return Response.json({
        'success': true,
        'message': 'User berhasil diperbarui',
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
          'message': 'Terjadi kesalahan saat memperbarui user: $e',
        }, 500);
      }
    }
  }

  // Menghapus data user
  Future<Response> destroy(Request request, String id) async {
    try {
      print('Searching for User ID: $id'); // Tambahkan log untuk debugging
      final result = await User()
          .query()
          .whereRaw('LOWER(user_id) = ?', [id.toLowerCase()]).first();
      print('Query Result: $result'); // Tambahkan log untuk debugging
      final user = result != null ? User.fromJson(result) : null;
      if (user == null) {
        return Response.json({
          'success': false,
          'message': 'User tidak ditemukan',
        });
      }
      print('Deleting User ID: $id'); // Tambahkan log untuk debugging
      await User()
          .query()
          .whereRaw('LOWER(user_id) = ?', [id.toLowerCase()]).delete();
      print('User ID: $id deleted'); // Tambahkan log untuk debugging

      return Response.json({
        'success': true,
        'message': 'User berhasil dihapus',
      });
    } catch (e) {
      print('Error: $e'); // Tambahkan log untuk debugging
      return Response.json({
        'success': false,
        'message': 'Gagal menghapus user: $e',
      });
    }
  }
}
