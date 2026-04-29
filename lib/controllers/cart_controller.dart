import 'dart:async';
import '../models/product.dart';

class CartController {
  // StreamController para la lista del carrito
  final _cartStreamController =
      StreamController<List<Product>>.broadcast();

  // StreamController para el total de items (contador del AppBar)
  final _itemCountController = StreamController<int>.broadcast();

  // StreamController para el precio total
  final _totalPriceController = StreamController<double>.broadcast();

  // Estado interno del carrito
  final List<Product> _cartItems = [];

  // Streams públicos (solo lectura)
  Stream<List<Product>> get cartStream => _cartStreamController.stream;
  Stream<int> get itemCountStream => _itemCountController.stream;
  Stream<double> get totalPriceStream => _totalPriceController.stream;

  // Getters síncronos
  List<Product> get cartItems => List.unmodifiable(_cartItems);
  int get itemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  void addProduct(Product product) {
    final index = _cartItems.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _cartItems[index] =
          _cartItems[index].copyWith(quantity: _cartItems[index].quantity + 1);
    } else {
      _cartItems.add(product.copyWith(quantity: 1));
    }
    _emitUpdates();
  }

  void removeProduct(String productId) {
    final index = _cartItems.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index] = _cartItems[index]
            .copyWith(quantity: _cartItems[index].quantity - 1);
      } else {
        _cartItems.removeAt(index);
      }
      _emitUpdates();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _emitUpdates();
  }

  // Emite actualizaciones a todos los streams
  void _emitUpdates() {
    _cartStreamController.add(List.from(_cartItems));
    _itemCountController.add(itemCount);
    _totalPriceController.add(totalPrice);
  }

  // Importante: cerrar los streams cuando ya no se usen
  void dispose() {
    _cartStreamController.close();
    _itemCountController.close();
    _totalPriceController.close();
  }
}