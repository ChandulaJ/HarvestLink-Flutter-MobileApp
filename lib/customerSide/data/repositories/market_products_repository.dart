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
  //
  // Future<List<MarketProductDataModel>> fetchMarketItemsByFarmerId(String farmerId) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
  //         .collection('MarketProducts')
  //         .where('FarmerId', isEqualTo: farmerId)
  //         .get();
  //
  //     List<MarketProductDataModel> products = snapshot.docs
  //         .map((doc) => MarketProductDataModel.fromSnapshot(doc))
  //         .toList();
  //
  //     return products;
  //   } catch (e) {
  //     print('Error fetching products for farmer: $e');
  //     throw e;
  //   }
  // }

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

  // Future<void> decreaseStockQuantity(String? productId, int quantity) async {
  //   try {
  //     // Get the reference to the MarketProducts document
  //     final marketProductRef =
  //     FirebaseFirestore.instance.collection('MarketProducts').doc(productId);

  //     // Decrease StockQuantity by the specified quantity
  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
  //       final marketProduct = await transaction.get(marketProductRef);
  //       final currentStockQuantity = marketProduct['StockQuantity'] ?? 0;
  //       final newStockQuantity = currentStockQuantity - quantity;

  //       if (newStockQuantity < 0) {
  //         throw Exception('Not enough stock available');
  //       }

  //       transaction.update(marketProductRef, {'StockQuantity': newStockQuantity});
  //     });
  //   } catch (e) {
  //     // Handle the error, e.g., log it or notify the user
  //     print('Error decreasing stock quantity: $e');
  //     throw e;
  //   }
  // }

}
