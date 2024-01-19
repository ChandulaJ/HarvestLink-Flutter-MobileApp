
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/models/farmer_data_model.dart';

class CustomerRepository extends GetxController{
  static CustomerRepository get instance =>Get.find();

  final _db = FirebaseFirestore.instance;


  static Future<void> addToCustomerCart({required String customerId,required String? productId,required double netPrice,required int productQuantity,required double unitPrice}) async {
    try {

      CollectionReference cartItemsRef = FirebaseFirestore.instance
          .collection('Customers')
          .doc(customerId)
          .collection('cartItems');

      await cartItemsRef.add({
        'ProductId': productId,
        'NetPrice': netPrice,
        'ProductQuantity': productQuantity,
        'UnitPrice': unitPrice,
      });

      print('Item added to customer cart successfully');
    } catch (e) {
      print('Error adding item to cart: $e');
      throw e;
    }
  }
}