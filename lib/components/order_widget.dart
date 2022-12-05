import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

/// Classe responsável por montar a estrutura da página de pedidos
class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({super.key, required this.order});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsHeight = (widget.order.products.length * 25) + 10;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? itemsHeight + 80 : 80,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _expanded ? itemsHeight.toDouble() : 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: ListView(
                  children: widget.order.products.map((product) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${product.quantity}x  R\$ ${product.price}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    );
                  }).toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
