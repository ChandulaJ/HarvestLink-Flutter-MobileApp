import 'harvest.dart';
import 'order.dart';

class OrderDetail{
  String detailId;
  int quantity;
  double price;
  String unit;
  Order order;
  Harvest item;

  OrderDetail({required this.detailId, required this.quantity, required this.price,required this.unit, required this.order,
      required this.item});

  void calSubTotal(){}

}