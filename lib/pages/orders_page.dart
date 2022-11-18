import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';

import '../components/order_widget.dart';
import '../models/order_list.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: orders.itemsCount > 0
          ? ListView.builder(
              itemCount: orders.itemsCount,
              itemBuilder: (cxt, i) => OrderWidget(order: orders.items[i]),
            )
          : const Card(
              child: Center(
                child: Text(
                  'Nenhum pedido realizado.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
    );
  }
}
