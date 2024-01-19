import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MarketProductDataModel {
  String productId;
  String farmerId;
  String name;
  double price;
  String imageUrl;
  String unit;
  int stockQuantity;
  Timestamp date;

  MarketProductDataModel({
    required this.productId,
    required this.farmerId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.unit,
    required this.stockQuantity,
    required this.date,
  });
  static MarketProductDataModel empty() {
    return MarketProductDataModel(
      productId: "",
      farmerId: "",
      name: "",
      price: 0,
      imageUrl: "",
      unit: "",
      stockQuantity: 0,
      date: Timestamp.fromDate(DateTime.now()),
    );
  }

  MarketProductDataModel copyWith({
    String? productId,
    String? farmerId,
    String? name,
    double? price,
    String? imageUrl,
    String? unit,
     int? stockQuantity,
    Timestamp? date,
  }) {
    return MarketProductDataModel(
      productId: this.productId,
      farmerId: farmerId ?? this.farmerId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      unit: unit ?? this.unit,
      stockQuantity: this.stockQuantity,
      date: date ?? this.date,
    );
  }
  // factory MarketProductDataModel.fromFirestore(
  //     Map<String, dynamic> map, String documentId) {
  //   return MarketProductDataModel(
  //     productId: documentId,
  //     farmerId: map['FarmerId'] ?? '',
  //     name: map['Name'] ?? '',
  //     price: (map['Price'] ?? 0).toDouble(),
  //     imageUrl: map['ImageUrl'] ?? '',
  //     unit: map['Unit'] ?? '',
  //     stockQuantity: (map['StockQuantity'] ?? 0).toDouble(),
  //     date: map['HarvestedDate'] ?? '',
  //   );
  // }

  factory MarketProductDataModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    print('hello');

    if (document.data() != null) {
      final data = document.data()!;

      return MarketProductDataModel(
        productId: document.id,
        farmerId: data['FarmerId'] ?? '',
        name: data['Name'] ?? '',
        price: data['Price'] ?? '',
        imageUrl: data['ImageUrl'] ?? '',
        unit: data['Unit'] ?? '',
        stockQuantity: data['StockQuantity'] ?? '',
        date: data['HarvestedDate'] ?? '',
      );
    } else {
      return MarketProductDataModel.empty();
    }
  }

  factory MarketProductDataModel.fromMap(Map<String, dynamic> map) {
    print("inside market product data model");
    return MarketProductDataModel(
      productId: map['uid'] ?? '',
      farmerId: map['FarmerId'] ?? '',
      name: map['Name'] ?? '',
      price: (map['Price'] ?? 0).toDouble(),
      imageUrl: map['ImageUrl'] ?? '',
      unit: map['Unit'] ?? '',
      stockQuantity: (map['StockQuantity'] ?? 0).toInt(),
      date: map['HarvestedDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FarmerId': farmerId,
      'Name': name,
      'Price': price,
      'ImageUrl': imageUrl,
      'Unit': unit,
      'StockQuantity': stockQuantity,
      'HarvestedDate': date,
    };
  }
}
