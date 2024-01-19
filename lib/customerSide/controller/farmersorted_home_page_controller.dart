import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/data/repositories/farmer_repository.dart';
import 'package:harvest_delivery/customerSide/models/farmer_data_model.dart';

class FarmerHomePageController extends GetxController {
  static FarmerHomePageController get instance => Get.find();
  final farmerRepository = Get.put(FarmerRepository());

  RxBool isLoading = false.obs;
  RxList<FarmerDataModel> farmers = <FarmerDataModel>[].obs;

  void onInit() {
   fetchFarmerDetails();
    super.onInit();
  }
  Future<void> fetchAll() async {
    fetchFarmerDetails();
    print('Fetching');
  }

  void fetchFarmerDetails() async {
    try {
      isLoading.value = true;
      final farmerDetails = await farmerRepository.getFarmers();
      print("farmers $farmerDetails");
      farmers.assignAll(farmerDetails);
    } catch (e) {
      SnackBar(content: Text("Error: ${e.toString()}"),);
    } finally {
      isLoading.value = false;
    }
  }
}