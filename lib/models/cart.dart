import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop/models/product.dart';

import 'cart_item.dart';

/// Entidade que representa o carrinho de compras
class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {...items};
  }

/// Retorna quantidade de itens no carrinho
  int get itemsCount {
    return _items.length;
  }

/// Método que calcula o valor total do carrinho
double get totalAmount {
  double total = 0.0;
  _items.forEach((key, cartItem) {
    total += cartItem.price * cartItem.quantity;
   });
   return total;
}

/// Método para adicionar ou remover itens do carrinho
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantity: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  /// Remove um item da lista
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  /// Limpa os dados da lista
  void clear() {
    _items = {};
    notifyListeners();
  }
}
