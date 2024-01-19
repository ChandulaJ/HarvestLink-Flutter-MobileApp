import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerDataModel {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phoneNumber;

  FarmerDataModel(
      {required this.id,
      required this.name,
      required this.address,
      required this.email,
      required this.phoneNumber});

  factory FarmerDataModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() == null) {
      return FarmerDataModel.empty();
    }
    print('Data from Firestore for document ID ${document.id}: $document.data');
    final data = document.data()!;

    return FarmerDataModel(
      id: document.id,
      name: data['Name'],
      address: data['Address'],
      email: data['Email'],
      phoneNumber: data['Phone number'].toString(),
    );
  }

  static FarmerDataModel empty() {
    return FarmerDataModel(
        id: '', name: '', address: '', email: '', phoneNumber: '');
  }
}
