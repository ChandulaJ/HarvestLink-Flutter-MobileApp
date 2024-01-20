// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:harvest_delivery/customerSide/controller/cart_page_controller.dart';
// import 'package:harvest_delivery/customerSide/models/cart_product_data_model.dart';
// import '../../models/market_product_data_model.dart';
// import '../pages/checkout_page.dart';
// import 'cart_tile.dart';
//
// class FilledCart extends StatelessWidget {
//   final CartPageController cartPageController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           "Your Cart",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 25.0,
//           ),
//           textAlign: TextAlign.left,
//         ),
//         Obx(() {
//           final List<CartProductDataModel> cartItems =
//           cartPageController.cartItems.toList();
//
//           return Expanded(
//             child: ListView.builder(
//               itemCount: cartItems.length,
//               itemBuilder: (context, index) {
//                 CartProductDataModel product = cartItems[index];
//
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 10.0),
//                   child: CartTile(
//
//                     price: product.netPrice,
//                     quantity: product.productQuantity, img: '', productName: '',
//                   ),
//                 );
//               },
//             ),
//           );
//         }),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
//           child: FilledButton(
//             onPressed: () {
//               Get.to(CheckoutPage());
//             },
//             child: const Text(
//               'Checkout',
//               style: TextStyle(fontSize: 18.0),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
