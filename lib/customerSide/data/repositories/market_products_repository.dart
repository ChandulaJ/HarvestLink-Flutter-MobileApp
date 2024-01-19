import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest_delivery/customerSide/models/market_product_data_model.dart';

class MarketProductsRepository {
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
          .map((doc) => MarketProductDataModel.fromMap(doc.data()))
          .toList();

      return marketItems;
    } catch (e) {
      print("Error fetching market items by farmer id: $e");
      throw e;
    }
  }
}
