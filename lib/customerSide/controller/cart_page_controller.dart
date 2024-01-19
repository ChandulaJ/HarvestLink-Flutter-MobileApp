import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/models/cart_product_data_model.dart';

import '../data/repositories/cart_products_repository.dart';
import '../models/market_product_data_model.dart';

class CartPageController {
  final CartProductsRepository _cartRepository = CartProductsRepository();
  final RxList<CartProductDataModel> cartItems = <CartProductDataModel>[].obs;

 

  @override
  onInit() {
    fetchCartData();
  }

  Future<void> addToCart(CartProductDataModel product) async {
    try {
      await _cartRepository.addToCart(product);
      fetchCartData();
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  Future<void> removeFromCart(CartProductDataModel product) async {
    try {
      await _cartRepository.removeFromCart(product);
      fetchCartData();
    } catch (e) {
      print("Error removing from cart: $e");
    }
  }

  Future<void> fetchCartData() async {
    try {
      List<CartProductDataModel> fetchedItems =
          await _cartRepository.fetchCartItems();
      cartItems.assignAll(fetchedItems);
    } catch (e) {
      print("Error fetching cart items: $e");
      // Return an empty list or another default value in case of an exception
    }
  }
}
