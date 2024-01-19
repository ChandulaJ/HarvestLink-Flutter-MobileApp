import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_delivery/customerSide/view/components/product_counter.dart';
import 'package:harvest_delivery/customerSide/view/pages/cart_page.dart';
import 'package:harvest_delivery/customerSide/view/pages/main_page.dart';

import '../../controller/home_page_controller.dart';
import '../../models/market_product_data_model.dart';
import 'checkout_page.dart';

class MoreDetailsPage extends StatefulWidget {

  final int itemIndex;
  final MarketProductDataModel product;

  MoreDetailsPage({Key? key, required this.itemIndex, required this.product})
      : super(key: key);

  @override
  State<MoreDetailsPage> createState() => _MoreDetailsPageState();
}

class _MoreDetailsPageState extends State<MoreDetailsPage> {

  final HomePageController homePageController = Get.find();
  var buycount = 0;

  void updateBuyCount(int count) {
    setState(() {
      buycount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_circle_left_rounded,
            color: Colors.black,
            size: 40.0,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250.0,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        image: widget.product.imageUrl.isNotEmpty
                            ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage( widget.product.imageUrl),
                        )
                            : DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('lib/customerSide/view/images/default_product_img.jpg'),
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'LKR. ${widget.product.price} per ${widget.product.unit}',
                          style: GoogleFonts.roboto(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.black45),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ProductCounter(
                          onCountChange: updateBuyCount,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FilledButton(
                onPressed: () {
                  homePageController.cartAddBtnPressed(widget.itemIndex,buycount.toDouble());
                  Get.to(CustomerMainPage());
                },
                child: Text(
                  'Add $buycount to cart - LKR ${buycount * widget.product.price}',
                  style: TextStyle(fontSize: 18.0),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Adjust the radius here
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
