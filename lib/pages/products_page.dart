import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

import '../components/product_item.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  /// Método para carregar os produtos após o pull do widget
  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Gerenciar produtos'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.productForm);
                },
                icon: const Icon(Icons.add))
          ]),
      drawer: const AppDrawer(),
      // Widget que carrega a lista de itens a partir de um provider ao dar o pull da página
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: [
                ProductsItem(
                  products.items[i],
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
