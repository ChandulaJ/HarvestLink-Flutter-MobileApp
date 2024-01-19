class Farmer {
  String farmerId;
  String name;
  String phoneNumber;
  String address;
  String email;
  String ?imageUrl;

  Farmer(
      {required this.farmerId,
      required this.name,
      required this.phoneNumber,
      required this.address,
      required this.email,
      this.imageUrl});

  void calEarnings() {}
}
