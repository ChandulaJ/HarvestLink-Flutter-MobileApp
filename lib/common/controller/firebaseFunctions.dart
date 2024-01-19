import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static saveCustomer(String name, email, uid) async {
    await FirebaseFirestore.instance
        .collection('Customers')
        .doc(uid)
        .set({'Email': email, 'Name': name, 'Address': '', 'Phone number': ''});
  }

  static saveFarmer(String name, email, uid) async {
    await FirebaseFirestore.instance
        .collection('Farmers')
        .doc(uid)
        .set({'Email': email, 'Name': name, 'Address': '', 'Phone number': ''});
  }


  static Future<String> getUserCollection(String uid) async {
    // Check the "Farmers" collection
    DocumentSnapshot farmerSnapshot = await FirebaseFirestore.instance.collection('Farmers').doc(uid).get();
    if (farmerSnapshot.exists) {
      return 'Farmers';
    }

    // Check the "Customers" collection
    DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance.collection('Customers').doc(uid).get();
    if (customerSnapshot.exists) {
      return 'Customers';
    }

     return '';
  }
}