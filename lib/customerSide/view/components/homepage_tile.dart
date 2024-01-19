import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_delivery/customerSide/view/pages/more_details_page.dart';

import '../../controller/home_page_controller.dart';

class HomePageTile extends StatelessWidget {
  final HomePageController homePageController = Get.find();
  final String img;
  final String productName;
  final double price;
  final int product_index;

  HomePageTile({
  Key? key,
  required this.img,
  required this.productName,
  required this.price,
  required this.product_index,
}) : super(key: key);


  @override
  Widget build(BuildContext context) {
     print('img: $img, productName: $productName, price: $price, product_index: $product_index');
   
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: img.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(img),
                    )
                  : DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'lib/customerSide/view/images/default_product_img.jpg'),
                    ), // Replace with your dummy image asset path
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            productName,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rs. ' + price.toString(),
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(MoreDetailsPage(
                          itemIndex: product_index,
                          product:
                              homePageController.marketItems[product_index]));
                      ;
                    },
                    // onPressed: () {homePageController.cartAddBtnPressed(product_index);},
                    icon: Icon(
                      Icons.add_circle,
                      size: 40,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
