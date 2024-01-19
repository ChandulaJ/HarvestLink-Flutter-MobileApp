import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest_delivery/customerSide/models/product_data_model.dart';


class MarketProductsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductDataModel>> fetchMarketItems() async {
    try {
print("fetching market data in repo");
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('MarketProducts').get();

      List<ProductDataModel> marketItems = snapshot.docs
          .map((doc) => ProductDataModel.fromMap(doc.data()))
          .toList();

      return marketItems;
    } catch (e) {

      print("Error fetching market items: $e");
      throw e;
    }
  }
}
