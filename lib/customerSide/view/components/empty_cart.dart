import 'package:flutter/cupertino.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
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
      )
    );
  }
}
