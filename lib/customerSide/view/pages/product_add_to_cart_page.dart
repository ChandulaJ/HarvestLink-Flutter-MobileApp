import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_delivery/common/controller/authFunctions.dart';
import 'package:harvest_delivery/customerSide/data/repositories/customer_repository.dart';
import 'package:harvest_delivery/customerSide/data/repositories/market_products_repository.dart';
import 'package:harvest_delivery/farmerSide/models/customer.dart';

import '../components/product_counter.dart';

class ProductAddToCartPage extends StatefulWidget {
  final String productId;
  final String img;
  final double pricePerUnit;
  final double stkQuantity;
  final String name;
  final String unit;

  const ProductAddToCartPage(
      {super.key,
      required this.img,
      required this.pricePerUnit,
      required this.stkQuantity,
      required this.name,
      required this.unit,
      required this.productId});

  @override
  State<ProductAddToCartPage> createState() => _ProductAddToCartPageState();
}

class _ProductAddToCartPageState extends State<ProductAddToCartPage> {
  RxInt buycount = 0.obs;

  Future<void> addToCart(
      {required String productId,
      required double pricePerUnit,
      required int productQuantity}) async {
    try {
      final String customerId = AuthServices().getCurrentUser()?.uid ?? "";
      final netPrice = pricePerUnit * productQuantity;
      final marketProductsRepository = MarketProductsRepository();
      await marketProductsRepository.decreaseStockQuantity(productId, productQuantity);



      await CustomerRepository.addToCustomerCart(
          customerId: customerId,
          productId: productId,
          netPrice: netPrice,
          productQuantity: productQuantity,
          unitPrice: pricePerUnit);

      // Show a success message or navigate to the cart page
      Get.snackbar('Success', 'Item added to cart successfully');
      Navigator.of(context).pop();
    } catch (e) {
      // Handle the error
      Get.snackbar('Error', 'Failed to add item to cart: $e');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    void updateBuyCount(int count) {
      setState(() {
        buycount.value = count;
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                      image: widget.img.isNotEmpty
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.img),
                            )
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'lib/customerSide/view/images/default_product_img.jpg'),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'LKR. ${widget.pricePerUnit} per ${widget.unit}',
                          style: GoogleFonts.roboto(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.black45),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ProductCounter(
                          stkCount: widget.stkQuantity.toInt(),
                          onCountChange: updateBuyCount,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'In Stock: ${widget.stkQuantity.toInt()} items',
                          style: GoogleFonts.roboto(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.green.shade700),
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
                onPressed: () async {
                  if (buycount.value == 0) {
                    Navigator.of(context).pop();
                    return;
                  }
                  await addToCart(
                      productId: widget.productId,
                      pricePerUnit: widget.pricePerUnit,
                      productQuantity: buycount.value);
                },
                child: Text(
                  'Add $buycount to cart - LKR ${buycount * widget.pricePerUnit}',
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
