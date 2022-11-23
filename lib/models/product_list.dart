import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

/// Classe que recebe as notificações do provider na classe ProductsOverviewPage
class ProductList with ChangeNotifier {
  final _baseUrl = 'https://shop-app-7a367-default-rtdb.firebaseio.com/';
  final List<Product> _items = dummyProducts;

  // Getter para retornar todos os itens ou apenas lista de itens filtrados
  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  /// Método que adiciona um produto na lista
  void addProduct(Product product) {
    http
        .post(
          Uri.parse('$_baseUrl/products.json'),
          body: jsonEncode(
            {
              'name': product.name,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'isFavorite': product.isFavorite
            },
          ),
        )
        .then((value) => (response) {
              final id = jsonDecode(response.body)['name'];
              _items.add(
                Product(
                  id: id,
                  name: product.name,
                  description: product.description,
                  price: product.price,
                  imageUrl: product.imageUrl,
                  isFavorite: product.isFavorite,
                ),
              );
            });

    // Método que notifica o provider da mudança da lista
    notifyListeners();
  }

  /// Método que realiza a adição o produto a lista notificando o provider  da alteração
  void saveProduct(Map<String, Object> data) {
    final hasId = data['id'] != null;

    final product = Product(
      // Salva o estado atual de cada campo do formulário
      id: hasId ? data['id'].toString() : Random().nextDouble().toString(),
      name: data['name'].toString(),
      description: data['description'].toString(),
      price: data['price'] as double,
      imageUrl: data['imageUrl'].toString(),
    );

    if (hasId) {
      updateProduct(product);
    } else {
      addProduct(product);
    }
    notifyListeners();
  }

  /// Atualiza o produto caso o índice do produto pertença a lista de itens
  void updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
    }
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

