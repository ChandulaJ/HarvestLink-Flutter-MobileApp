import 'package:flutter/material.dart';
import '../data/repositories/cart_products_repository.dart';
import '../models/cart_product_data_model.dart';

class CartPageController extends StatefulWidget {
  final String customerId;

  const CartPageController({Key? key, required this.customerId})
      : super(key: key);

  @override
  _CartPageControllerState createState() => _CartPageControllerState();
}

class _CartPageControllerState extends State<CartPageController> {
  late List<CartProductDataModel> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      List<CartProductDataModel> fetchedCartItems =
          await CartProductRepository.getCustomerCart(widget.customerId);
      setState(() {
        cartItems = fetchedCartItems;
      });
    } catch (e) {
      // Handle error
      print('Error fetching cart items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartItems == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : cartItems.isEmpty
              ? Center(
                child: Column(
                        children: [
                          Text(
                            "Your Cart",
                            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 20.0,),
                          Image.asset("lib/customerSide/view/images/empty-cart.png",height: 160.0,width: 160.0,),
                          Text("Looks like your cart is empty 😕")
                        ],
                      ),
              )
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cartItems[index].productName),
                      subtitle: Text(
                          'Price:  LKR ${cartItems[index].netPrice.toStringAsFixed(2)}'),
                      trailing:
                          Text('Quantity: ${cartItems[index].productQuantity}'),
                    );
                  },
                ),
    );
  }
}
