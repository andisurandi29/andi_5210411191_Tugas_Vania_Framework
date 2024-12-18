import 'package:vania/vania.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../../models/users.dart';
import 'package:vania/src/exception/validation_exception.dart';

class LoginController extends Controller {
  // Fungsi login
  Future<Response> login(Request request) async {
    try {
      // Validasi input
      request.validate({
        'email': 'required|email',
        'password': 'required',
      }, {
        'email.required': 'Email tidak boleh kosong',
        'email.email': 'Email tidak valid',
        'password.required': 'Password tidak boleh kosong',
      });

      final requestData = request.input();
      final email = requestData['email'];
      final password = requestData['password'];

      // Cari user berdasarkan email
      final user = await User().query().where('user_email', email).first();

      if (user != null) {
        // Hash password yang diinputkan dan bandingkan dengan hash yang disimpan
        final hashedPassword = sha256.convert(utf8.encode(password)).toString();
        if (user['user_password'] == hashedPassword) {
          // Buat token JWT
          final jwt = JWT({
            'id': user['user_id'],
            'email': user['user_email'],
          });

          // Tandatangani token dengan secret key
          final token = jwt.sign(SecretKey('your-256-bit-secret'));

          // Login berhasil
          return Response.json({
            'success': true,
            'message': 'Login berhasil',
            'token': token,
            'data': user,
          });
        }
      }

      // Kredensial tidak valid
      return Response.json({
        'success': false,
        'message': 'Email atau password tidak valid',
      }, 401);
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
          'message': 'Terjadi kesalahan saat login: $e',
        }, 500);
      }
    }
  }
}
