import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';

class CardItemWidget extends StatelessWidget{
final CartItem cartItem;

  const CardItemWidget(this.cartItem, {super.key,});

  @override
  Widget build(BuildContext context) {
    return Text(cartItem.name);
  }
  
}