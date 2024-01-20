class CartProductDataModel {
  final String productId;
  final double netPrice;
  final int productQuantity;

  var productName;

  CartProductDataModel({
    required this.productId,
    required this.netPrice,
    required this.productQuantity,
    required this.productName,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'netPrice': netPrice,
      'productQuantity': productQuantity,
      'productName': productName,
    };
  }

  factory CartProductDataModel.fromMap(Map<String, dynamic> map) {
    //print the map
    print(map);
    return CartProductDataModel(
      productId: map['productId'],
      netPrice: map['netPrice'],
      productQuantity: map['productQuantity'],
      productName: map['productName'] ?? '',
    );
  }
}
