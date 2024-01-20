import 'package:flutter/material.dart';

import '../../controller/cart_page_controller.dart';


class CartPage extends StatelessWidget {
  final String customerId;

  const CartPage({Key? key, required this.customerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CartPageController(customerId: customerId);
  }
}
