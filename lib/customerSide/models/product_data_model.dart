class ProductDataModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String unit;
  final double quantity;
  final String userId;

  ProductDataModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.unit,
    required this.quantity,
    required this.userId,
  });


  ProductDataModel copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? unit,
    double? quantity,
    String? userId,
  }) {
    return ProductDataModel(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        unit: unit ?? this.unit,
        quantity: quantity ?? this.quantity,
        userId: userId ?? this.userId);
  }

  factory ProductDataModel.fromMap(Map<String, dynamic> map) {
    print("inside product data model");
    return ProductDataModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      unit: map['unit'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      userId: map['userId'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'unit': unit,
      'quantity': quantity,
      'userId': userId,
    };
  }
}
