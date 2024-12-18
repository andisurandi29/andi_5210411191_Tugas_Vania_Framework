import 'package:vania/vania.dart';
import 'package:shelf/shelf.dart' as shelf;
import '../app/http/controllers/customer_controller.dart';
import '../app/http/controllers/vendor_controller.dart';
import '../app/http/controllers/product_controller.dart';
import '../app/http/controllers/order_controller.dart';
import '../app/http/controllers/order_item_controller.dart';
import '../app/http/controllers/product_note_controller.dart';
import '../app/http/controllers/user_controller.dart';
import '../app/http/controllers/login_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base Router
    Router.basePrefix('api');

    Router.get('/', (shelf.Request request) {
      return shelf.Response.ok('Selamat datang di API V1');
    });

    Router.post(
        '/login', (Request request) => LoginController().login(request));

    // Users routes
    Router.get('/users', (Request request) => UserController().index(request));
    Router.get('/users/{id}',
        (Request request, String id) => UserController().show(request, id));
    Router.post('/users', (Request request) => UserController().store(request));
    Router.put('/users/{id}',
        (Request request, String id) => UserController().update(request, id));
    Router.delete('/users/{id}',
        (Request request, String id) => UserController().destroy(request, id));

    // Customer routes
    Router.get(
        '/customers', (Request request) => CustomerController().index(request));
    Router.get('/customers/{id}', (String id) => CustomerController().show(id));
    Router.post(
        '/customers', (Request request) => CustomerController().store(request));
    Router.put(
        '/customers/{id}',
        (Request request, String id) =>
            CustomerController().update(request, id));
    Router.delete(
        '/customers/{id}', (String id) => CustomerController().destroy(id));

    // Vendor routes
    Router.get(
        '/vendors', (Request request) => VendorController().index(request));
    Router.get('/vendors/{id}',
        (Request request, String id) => VendorController().show(request, id));
    Router.post(
        '/vendors', (Request request) => VendorController().store(request));
    Router.put('/vendors/{id}',
        (Request request, String id) => VendorController().update(request, id));
    Router.delete(
        '/vendors/{id}',
        (Request request, String id) =>
            VendorController().destroy(request, id));

    // Product routes
    Router.get(
        '/products', (Request request) => ProductController().index(request));
    Router.get('/products/{id}',
        (Request request, String id) => ProductController().show(request, id));
    Router.post(
        '/products', (Request request) => ProductController().store(request));
    Router.put(
        '/products/{id}',
        (Request request, String id) =>
            ProductController().update(request, id));
    Router.delete(
        '/products/{id}',
        (Request request, String id) =>
            ProductController().destroy(request, id));

    // Order routes
    Router.get(
        '/orders', (Request request) => OrderController().index(request));
    Router.get('/orders/{id}',
        (Request request, int id) => OrderController().show(request, id));
    Router.post(
        '/orders', (Request request) => OrderController().store(request));
    Router.put('/orders/{id}',
        (Request request, int id) => OrderController().update(request, id));
    Router.delete('/orders/{id}',
        (Request request, int id) => OrderController().destroy(request, id));

    // OrderItem routes
    Router.get('/order-items',
        (Request request) => OrderItemController().index(request));
    Router.get('/order-items/{id}',
        (Request request, int id) => OrderItemController().show(request, id));
    Router.post('/order-items',
        (Request request) => OrderItemController().store(request));
    Router.put('/order-items/{id}',
        (Request request, int id) => OrderItemController().update(request, id));
    Router.delete(
        '/order-items/{id}',
        (Request request, int id) =>
            OrderItemController().destroy(request, id));

    // ProductNote routes
    Router.get('/product-notes',
        (Request request) => ProductNoteController().index(request));
    Router.get(
        '/product-notes/{id}',
        (Request request, String id) =>
            ProductNoteController().show(request, id));
    Router.post('/product-notes',
        (Request request) => ProductNoteController().store(request));
    Router.put(
        '/product-notes/{id}',
        (Request request, String id) =>
            ProductNoteController().update(request, id));
    Router.delete(
        '/product-notes/{id}',
        (Request request, String id) =>
            ProductNoteController().destroy(request, id));
  }
}
