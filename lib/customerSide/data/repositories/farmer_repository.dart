
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/models/farmer_data_model.dart';

class FarmerRepository extends GetxController{
  static FarmerRepository get instance =>Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<FarmerDataModel>> getFarmers() async{
    try{
      final snapshot = await _db.collection("Farmers").get();
      // Print the document data
      snapshot.docs.forEach((document) {
        print('Document ID: ${document.id}, Data: ${document.data()}');
      });

      List<FarmerDataModel> farmers = snapshot.docs.map((document){
        return FarmerDataModel.fromSnapshot(document);
      }).toList();
return farmers;

    }catch(e){
      print('Error fetching farmer details in farmer repository: $e');

      throw 'Something went wrong in farmer_repository';
    }
  }
}