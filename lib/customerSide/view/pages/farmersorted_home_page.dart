import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/controller/farmersorted_home_page_controller.dart';
import 'package:harvest_delivery/customerSide/models/farmer_data_model.dart';
import 'package:harvest_delivery/customerSide/view/components/farmersorted_home_page_tile.dart';
import '../../controller/home_page_controller.dart';
import '../../models/product_data_model.dart';
import '../components/homepage_tile.dart';

class FarmerSortedCustomerHomePage extends StatefulWidget {
  @override
  State<FarmerSortedCustomerHomePage> createState() =>
      _FarmerSortedCustomerHomePageState();
}

class _FarmerSortedCustomerHomePageState
    extends State<FarmerSortedCustomerHomePage> {
  final FarmerHomePageController farmerhomePageController = Get.put(FarmerHomePageController());

  @override
  void initState() {
    super.initState();
    farmerhomePageController.fetchFarmerDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<FarmerDataModel> farmerList = farmerhomePageController.farmers;

      return ListView.builder(
        itemCount: farmerList.length,
        itemBuilder: (context, index) {
          FarmerDataModel farmer = farmerList[index];

          return FarmersortedHomePageTile(
            name: farmer.name,
            address: farmer.address,
            email: farmer.email,
            phoneNumber: farmer.phoneNumber,
          );
        },
      );
    });
  }
}
