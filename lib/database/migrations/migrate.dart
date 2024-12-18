import 'dart:io';
import 'package:vania/vania.dart';
import 'create_customers_table.dart';
import 'create_vendors_table.dart';
import 'create_products_table.dart';
import 'create_orders_table.dart';
import 'create_order_items.dart';
import 'create_product_notes.dart';
import 'create_users_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateUsersTable().up();
    await CreateCustomersTable().up();
    await CreateVendorsTable().up();
    await CreateProductsTable().up();
    await CreateOrdersTable().up();
    await CreateOrderItemsTable().up();
    await CreateProductNotesTable().up();
  }

  dropTables() async {
    await CreateUsersTable().down();
    await CreateCustomersTable().down();
    await CreateVendorsTable().down();
    await CreateProductsTable().down();
    await CreateOrdersTable().down();
    await CreateOrderItemsTable().down();
    await CreateProductNotesTable().down();
  }
}
