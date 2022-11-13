import 'package:flutter/cupertino.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

/// Classe que recebe as notificações do provider na classe ProductsOverviewPage
class ProductList with ChangeNotifier {
  
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

/// Método que adiciona um produto na lista
  void addProduct(Product product){
    _items.add(product);
    // Método que notifica o provider da mudança da lista
    notifyListeners();
  }
}