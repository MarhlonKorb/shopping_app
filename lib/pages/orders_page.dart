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
      // Componente que pode ser utilizado em componentes do tipo Stateless e conter um estado
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(
                child: Text('Ocorreu um erro ao carregar a lista de pedidos.'));
          } else {
            return Consumer<OrderList>(
              builder: (context, value, child) => ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (cxt, i) => OrderWidget(order: orders.items[i]),
              ),
            );
          }
        },
      ),
    );
  }
}
