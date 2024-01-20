import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/models/market_product_data_model.dart';

class MarketProductsRepository {
  static MarketProductsRepository get instance =>Get.find();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MarketProductDataModel>> fetchMarketItems() async {
    try {
      print("fetching market data in market repo");
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('MarketProducts').get();

      List<MarketProductDataModel> marketItems = snapshot.docs
          .map((doc) => MarketProductDataModel.fromMap(doc.data()))
          .toList();

      return marketItems;
    } catch (e) {
      print("Error fetching market items: $e");
      throw e;
    }
  }

  Future<int> getStockQuantity(String productId) async {
    try {
      // Assume you have a 'products' collection in Firestore
      // and each document has a 'stockQuantity' field
      final DocumentSnapshot<Map<String, dynamic>> productSnapshot =
      await _firestore.collection('products').doc(productId).get();

      if (productSnapshot.exists) {
        // Get the stockQuantity from the document
        final int stockQuantity = productSnapshot['stockQuantity'] ?? 0;
        return stockQuantity;
      } else {
        // Product not found
        return 0;
      }
    } catch (e) {
      print('Error getting stock quantity: $e');
      throw e;
    }
  }



  Future<List<MarketProductDataModel>> fetchMarketItemsByFarmerId(
      String farmerId) async {
    try {
      print("fetching market data by farmer id in market repo");

      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('MarketProducts')
          .where('FarmerId',
              isEqualTo:
                  farmerId)
          .get();

      List<MarketProductDataModel> marketItems = snapshot.docs
          .map((doc) => MarketProductDataModel.fromSnapshot(doc))
          .toList();

      return marketItems;
    } catch (e) {
      print("Error fetching market items by farmer id: $e");
      throw e;
    }
  }
  

 Future<void> updateStockQuantity(String productId, int newStockQuantity) async {
    try {
      await _firestore
          .collection('MarketProducts')
          .doc(productId)
          .update({'StockQuantity': newStockQuantity});
    } catch (e) {
      print('Error updating stock quantity: $e');
      throw e;
    }
  }



}
