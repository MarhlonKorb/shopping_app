import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/cart.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ao invés de termos o product no construtor da classe,
    // é possivel obter o provider de Product para receber os dados da lista de forma atualizada
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    // Atributo 'listen' do provider permite configurar se uma mudança deve ser notificada ou não
    // É utilizado em casos onde as alterações não geram impacto na interface gráfica do app=
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // Utilizando o Consumer, é possível notificar a mudança em lugares específicos dos componentes
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              onPressed: () {
                product.toggleFavorite();
              },
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              // Snackbar de mensagem que possibilita desfazer a inserção de produtos no carrinho
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Produto adicionado com sucesso'),
                  duration: const Duration(milliseconds: 2500),
                  action: SnackBarAction(
                      label: 'Desfazer',
                      onPressed: () {
                        cart.removeSigleItem(product.id);
                      }),
                ),
              );
              cart.addItem(product);
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.productDetail,
              arguments: product,
            );
          },
        ),
      ),
    );
  }
}
