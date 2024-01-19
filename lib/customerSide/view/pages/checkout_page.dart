import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/models/cart_product_data_model.dart';
import 'package:harvest_delivery/customerSide/view/components/checkout_tile.dart';
import 'package:harvest_delivery/customerSide/view/pages/order_placed_page.dart';

import '../../controller/cart_page_controller.dart';
import '../../models/market_product_data_model.dart';
import '../components/cart_tile.dart';

class CheckoutPage extends StatelessWidget {
  CheckoutPage({super.key});
  final CartPageController cartPageController = Get.find();

  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (CartProductDataModel product in cartPageController.cartItems) {
      totalPrice += (product.price * product.cartQuantity);
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartPageController.cartItems.length,
              itemBuilder: (context, index) {
                CartProductDataModel product = cartPageController.cartItems[index];

                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CheckoutTile(
                    img: product.imageUrl,
                    productName: product.name,
                    price: product.price,
                    quantity: product.cartQuantity,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${calculateTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                FilledButton(
                  onPressed: () {
                    Get.to(OrderPlacedPage());
                  },
                  child: const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
