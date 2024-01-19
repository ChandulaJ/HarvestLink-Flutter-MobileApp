import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harvest_delivery/customerSide/models/product_data_model.dart';

class CartProductsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //get the current login user
  final user = FirebaseAuth.instance.currentUser;
  Future<void> addToCart(ProductDataModel product) async {
    product = product.copyWith(userId: user!.uid);
    try {
      await _firestore.collection('CartProducts').add(product.toJson());
    } catch (e) {
      print("Error adding to cart: $e");
      throw e;
    }
  }

  Future<void> removeFromCart(ProductDataModel product) async {
    try {
      await _firestore.collection('CartProducts').doc(product.id).delete();
    } catch (e) {
      print("Error removing from cart: $e");
      throw e;
    }
  }

  Future<List<ProductDataModel>> fetchCartItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('CartProducts').get();

      List<ProductDataModel> cartItems = snapshot.docs
          .map((doc) => ProductDataModel.fromMap(doc.data()))
          .toList();

      return cartItems;
    } catch (e) {
      print("Error fetching cart items: $e");
      throw e;
    }
  }
}
