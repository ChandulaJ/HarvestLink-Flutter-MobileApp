import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/cart_product_data_model.dart';


class CustomerRepository {
  static Future<void> addToCustomerCart({
    required String customerId,
    required String? productId,
    required double netPrice,
    required int productQuantity,
    required String productName,
  }) async {
    try {
      CollectionReference cartItemsRef = FirebaseFirestore.instance
          .collection('Customers')
          .doc(customerId)
          .collection('cartItems');

      await cartItemsRef.add(
        CartProductDataModel(
          productId: productId!,
          netPrice: netPrice,
          productQuantity: productQuantity,
          productName: productName,
        ).toMap(),
      );

      print('Item added to customer cart successfully');
    } catch (e) {
      print('Error adding item to cart: $e');
      throw e;
    }
  }
}
