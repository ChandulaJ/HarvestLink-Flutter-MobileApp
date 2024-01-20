import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/data/repositories/cart_products_repository.dart';
import 'package:harvest_delivery/customerSide/data/repositories/market_products_repository.dart';

import '../../common/controller/authFunctions.dart';
import 'cart_page_controller.dart';
import '../models/market_product_data_model.dart';

class HomePageController extends GetxController {
  final MarketProductsRepository _marketRepository = MarketProductsRepository();

  late BuildContext context;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CartPageController cartController; // Declare but don't initialize here

  late BuildContext homeContext;
  static HomePageController instance = Get.find<HomePageController>();

  final RxList<MarketProductDataModel> marketItems = <MarketProductDataModel>[].obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxString searchValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    String customerId = AuthServices().getCurrentUser()?.uid ?? 'yourCustomerId';

    cartController = CartPageController(customerId: customerId,);
  }

  Future<void> fetchMarketData() async {
    try {
      print("Fetching market data");
      List<MarketProductDataModel> fetchedItems = await _marketRepository.fetchMarketItems();
      marketItems.assignAll(fetchedItems);
    } catch (e) {
      print("Error fetching market items: $e");
    }
  }

  void cartAddBtnPressed(int index, double qty) {
    MarketProductDataModel productToAdd = marketItems[index];

    // TODO: implement add to cart
    // cartController.addToCart(productToAdd);

    showSnackBar();
  }

  List<String> getMarketItemNames() {
    return marketItems.map((item) => item.name).toList();
  }

  MarketProductDataModel getMarketItemByIndex(int index) {
    return marketItems[index];
  }

  List<MarketProductDataModel> getFilteredProducts(String searchValue) {
    if (searchValue.isEmpty) {
      return marketItems;
    } else {
      return marketItems
          .where((product) => product.name.toLowerCase().contains(searchValue.toLowerCase()))
          .toList();
    }
  }

  void setSearchValue(String value) {
    if (searchValue.value != value) {
      searchValue.value = value;
    }

    print("The controller value: $searchValue");
  }

  void setSelectedTabIndex(int index) {
    selectedTabIndex.value = index;
  }

  void setContext(BuildContext context) {
    this.context = context;
    instance = this;
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item added to the cart!'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            HomePageController.instance.setSelectedTabIndex(1);
          },
        ),
      ),
    );
  }
}
