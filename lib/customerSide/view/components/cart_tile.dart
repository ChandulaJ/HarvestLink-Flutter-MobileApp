  import 'package:flutter/material.dart';

  class CartTile extends StatelessWidget {
    final String img;
    final String productName;
    final double price;
    final int quantity;

    const CartTile({
      Key? key,
      required this.img,
      required this.productName,
      required this.price,
      required this.quantity,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(right: 10.0,left: 10.0),
        child: Container(
          height: 100.0,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey.shade200,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    height: 80.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                        image: img.isNotEmpty
                            ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(img),
                        )
                            : DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('lib/customerSide/view/images/default_product_img.jpg'),
                        ),
                    ),
                  ),
                ),
                SizedBox(width: 5.0,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(

                        child: Text(
                          productName,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Rs.  ${(price * quantity).toString()}',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
