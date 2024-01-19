import 'package:cloud_firestore/cloud_firestore.dart';

class MarketProductDataModel {
  final String farmerId;
  final String name;
  final double price;
  final String imageUrl;
  final String unit;
  final double stockQuantity;
  final Timestamp date;

  MarketProductDataModel({
    required this.farmerId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.unit,
    required this.stockQuantity,
    required this.date,
  });

  MarketProductDataModel copyWith({
    String? farmerId,
    String? name,
    double? price,
    String? imageUrl,
    String? unit,
    double? stockQuantity,
    Timestamp? date,
  }) {
    return MarketProductDataModel(
        farmerId: farmerId ?? this.farmerId,
        name: name ?? this.name,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        unit: unit ?? this.unit,
        stockQuantity: stockQuantity ?? this.stockQuantity,
        date: date ?? this.date);
  }

  factory MarketProductDataModel.fromMap(Map<String, dynamic> map) {
    print("inside market product data model");
    return MarketProductDataModel(
      farmerId: map['FarmerId'] ?? '',
      name: map['Name'] ?? '',
      price: (map['Price'] ?? 0).toDouble(),
      imageUrl: map['ImageUrl'] ?? '',
      unit: map['Unit'] ?? '',
      stockQuantity: (map['StockQuantity'] ?? 0).toDouble(),
      date: map['HarvestedDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': farmerId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'unit': unit,
      'quantity': stockQuantity,
      'date':date,

    };
  }
}
