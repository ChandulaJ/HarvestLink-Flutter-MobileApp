import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/view/components/cart_tile.dart';
import 'package:harvest_delivery/customerSide/controller/cart_page_controller.dart';
import '../../models/product_data_model.dart';
import '../components/empty_cart.dart';
import '../components/filled_cart.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  final CartPageController cartController = Get.put(CartPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          

          return cartController.cartItems.isEmpty ? EmptyCart() : FilledCart();
        }),
      ),
    );
  }
}
