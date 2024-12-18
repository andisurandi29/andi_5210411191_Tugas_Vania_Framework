import 'package:vania/vania.dart';

class CreateUsersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('users', () {
      string('user_id', length: 5, unique: true);
      string('user_name', length: 50);
      string('user_email', length: 50, unique: true);
      string('user_password', length: 100);
      timeStamps();

      primary('user_id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}