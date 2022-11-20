import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductsItem extends StatelessWidget {
  final Product product;

  const ProductsItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.productForm, arguments: product);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                      title: const Text('Excluir produto'),
                      content: const Text('Tem certeza?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                            child: const Text('Não')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(true);
                            },
                            child: const Text('Sim')),
                      ]),
                ).then((value) {
                  if (value ?? false) {
                    Provider.of<ProductList>(context, listen: false)
                        .removeProduct(product);
                  }
                });
                // Provider.of<ProductList>(context, listen: false)
                //     .removeProduct(product);
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
