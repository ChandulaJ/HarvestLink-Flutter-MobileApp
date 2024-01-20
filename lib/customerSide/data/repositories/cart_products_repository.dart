import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/cart_product_data_model.dart';

class CartProductRepository {
  static Future<List<CartProductDataModel>> getCustomerCart(String customerId) async {
    try {
      CollectionReference cartItemsRef = FirebaseFirestore.instance
          .collection('Customers')
          .doc(customerId)
          .collection('cartItems');

      QuerySnapshot querySnapshot = await cartItemsRef.get();

      List<CartProductDataModel> cartItems = querySnapshot.docs.map(
            (doc) => CartProductDataModel.fromMap(doc.data() as Map<String, dynamic>),
      ).toList();

    //print cartitems
      print(cartItems);
      return cartItems;
    } catch (e) {
      print('Error fetching cart items: $e');
      throw e;
    }
  }
}
