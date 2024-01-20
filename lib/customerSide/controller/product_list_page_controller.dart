import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/data/repositories/market_products_repository.dart';
import 'package:harvest_delivery/customerSide/models/market_product_data_model.dart';

class ProductListPageController extends GetxController{
  static ProductListPageController get instance => Get.find();
  final marketProductsRepository = Get.put(MarketProductsRepository());

  RxList<MarketProductDataModel> farmerProducts = <MarketProductDataModel>[].obs;

  void fetchFarmerProducts(String farmerID) async {
    try {
      final farmerProductsList = await marketProductsRepository.fetchMarketItemsByFarmerId(farmerID);
      print("farmer products $farmerProducts");
      farmerProducts.assignAll(farmerProductsList);
      print(" farmer products assigned");
    } catch (e) {
      SnackBar(content: Text("Error: ${e.toString()}"),);
    }
  }
}