class Customer {
  String customerId;
  String name;
  String phoneNumber;
  String address;
  String email;

  Customer(
      {required this.customerId,
      required this.name,
      required this.phoneNumber,
      required this.address,
      required this.email});

  void viewOrderHistory() {}
}
