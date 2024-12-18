import 'package:vania/vania.dart';

class User extends Model {
  String? user_id;
  String? user_name;
  String? user_email;
  String? user_password;
  String? user_phone;

  User({
    this.user_id,
    this.user_name,
    this.user_email,
    this.user_password,
    this.user_phone,
  }) {
    super.table('users');
  }

  // Konversi dari JSON ke objek User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_id: json['user_id'],
      user_name: json['user_name'],
      user_email: json['user_email'],
      user_password: json['user_password'],
      user_phone: json['user_phone'],
    );
  }

  // Konversi dari objek User ke JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'user_name': user_name,
      'user_email': user_email,
      'user_password': user_password,
      'user_phone': user_phone,
    };
  }
}