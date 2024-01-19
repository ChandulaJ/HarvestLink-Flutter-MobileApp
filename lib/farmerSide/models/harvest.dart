import 'Farmer.dart';

class Harvest {
  String produceId;
  String name;
  double price;
  int quantity;
  String unit;
  DateTime ?harvestedDate;
  String image;
  String farmerId;

  Harvest({
    required this.produceId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.harvestedDate,
    required this.image,
    required this.farmerId,
  });

  void inStock() {}
}
