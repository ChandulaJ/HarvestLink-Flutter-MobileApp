import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_page_controller.dart';
import '../../models/market_product_data_model.dart';
import '../components/homepage_tile.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final HomePageController homePageController = Get.find();

  @override
  void initState() {
    super.initState();
    homePageController.setContext(context);
    homePageController.fetchMarketData();
  }

  @override
  Widget build(BuildContext context) {
    homePageController.setContext(context);
    return Obx(() {
      String searchValue = homePageController.searchValue.toString();
      List<MarketProductDataModel> filteredProducts =
          homePageController.getFilteredProducts(searchValue);

      return ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          MarketProductDataModel product = filteredProducts[index];

          return HomePageTile(
            img: product.imageUrl,
            productName: product.name,
            price: product.price,
            product_index: index,
          );
        },
      );
    });
  }
}
