import 'package:flutter/cupertino.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

/// Classe que recebe as notificações do provider na classe ProductsOverviewPage
class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  // Getter para retornar todos os itens ou apenas lista de itens filtrados
  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  /// Método que adiciona um produto na lista
  void addProduct(Product product) {
    _items.add(product);
    // Método que notifica o provider da mudança da lista
    notifyListeners();
  }
}
  // final List<Product> _items = dummyProducts;
  // bool _showFavoriteOnly = false;
  
  // // Getter para retornar todos os itens ou apenas lista de itens filtrados
  // List<Product> get items {
  //   if (_showFavoriteOnly) {
  //     return _items.where((produto) => produto.isFavorite).toList();
  //   }
  //   return [..._items];
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

