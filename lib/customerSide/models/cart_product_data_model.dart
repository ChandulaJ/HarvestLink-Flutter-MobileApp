class CartProductDataModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String unit;
  final double cartQuantity;
  final String userId;

  CartProductDataModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.unit,
    required this.cartQuantity,
    required this.userId,
  });

  CartProductDataModel copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? unit,
    double? cartQuantity,
    String? userId,
  }) {
    return CartProductDataModel(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        unit: unit ?? this.unit,
        cartQuantity: cartQuantity ?? this.cartQuantity,
        userId: userId ?? this.userId);
  }

  factory CartProductDataModel.fromMap(Map<String, dynamic> map) {
    print("inside cart product data model");
    return CartProductDataModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      unit: map['unit'] ?? '',
      cartQuantity: (map['quantity'] ?? 0).toDouble(),
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
      'quantity': cartQuantity,
      'userId':userId,

    };
  }
}
