import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/controller/cart_page_controller.dart';
import 'package:harvest_delivery/customerSide/models/market_product_data_model.dart';
import '../../models/cart_product_data_model.dart';
import '../pages/checkout_page.dart';
import 'cart_tile.dart';

class FilledCart extends StatefulWidget {
  @override
  State<FilledCart> createState() => _FilledCartState();
}

class _FilledCartState extends State<FilledCart> {
  final CartPageController cartPageController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Your Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          textAlign: TextAlign.left,
        ),
        Obx(() {
          return Expanded(
            child: ListView.builder(
              itemCount: cartPageController.cartItems.length,
              itemBuilder: (context, index) {
                CartProductDataModel product = cartPageController.cartItems[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CartTile(
                    img: product.imageUrl,
                    productName: product.name,
                    price: product.price,
                    quantity: product.cartQuantity,
                  ),
                );
              },
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
          child: FilledButton(
            onPressed: () {
              Get.to(CheckoutPage());
            },
            child: const Text(
              'Checkout',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        )
      ],
    );
  }
}
