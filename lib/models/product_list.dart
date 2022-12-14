import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

/// Classe que recebe as notificações do provider na classe ProductsOverviewPage
class ProductList with ChangeNotifier {
  // Token que está sendo passado através do ChangeNofitierProxyProvider
  String _token;
  String _userId;
  List<Product> _items = [];

  // Getter para retornar todos os itens ou apenas lista de itens filtrados
  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  // Contrutor da classe
  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  /// Carrega os produtos do banco de dados
  Future<void> loadProducts() async {
    _items.clear();
    final response = await http
        .get(Uri.parse('${Constants.productBaseUrl}.json?=auth=$_token'));
    if (response.body == 'null') return;

    // Recupera os dados de userFavorites
    final favoriteResponse = await http.get(
      Uri.parse('${Constants.userFavoritesUrl}/$_userId.json?=auth=$_token'),
    );

  // Recebe as informações da requisição e caso não seja nulo armazena os dados no map
    Map<String, dynamic> favoriteData =
        favoriteResponse.body == null ? {} : jsonDecode(favoriteResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      // Recupera o value do userFavorite de acordo com a chave do productId e passa por parâmetro para o produto adicionado
      bool isFavorite = favoriteData[productId] ?? false;
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  /// Método que adiciona um produto na lista
  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.productBaseUrl}.json?=auth=$_token'),
      body: jsonEncode(
        {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    // Método que notifica o provider da mudança da lista
    notifyListeners();
  }

  /// Método que realiza a adição o produto a lista notificando o provider  da alteração
  Future<void> saveProduct(Map<String, Object> data) {
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
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  /// Atualiza o produto caso o índice do produto pertença a lista de itens
  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.productBaseUrl}/${product.id}.json?=auth=$_token'),
        body: jsonEncode(
          {
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  /// Exclui um produto da lista
  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.productBaseUrl}/${product.id}.json?=auth=$_token'),
      );

      // Caso o status code seja de erro(400), o item é retornado a lista de itens
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
            message: 'Não foi possível excluir o produto ${product.id}.',
            statusCode: response.statusCode);
      }
    }
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

