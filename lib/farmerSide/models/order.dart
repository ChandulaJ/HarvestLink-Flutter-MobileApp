import 'customer.dart';

class Order{
  String orderId;
  String date;
  String time;
  Customer customer;

  Order({required this.orderId, required this.date, required this.time, required this.customer});

  void calTotal(){}
  void placeOrder(){}

}