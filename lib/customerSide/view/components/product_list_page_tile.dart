import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/controller/product_list_page_controller.dart';
import 'package:harvest_delivery/customerSide/view/pages/more_details_page.dart';
import 'package:harvest_delivery/customerSide/view/pages/product_add_to_cart_page.dart';

class ProductListedPageTile extends StatelessWidget {
  final ProductListPageController productListPageController = Get.find();
  final String productID;
  final String harvestDate;
  final String unit;
  final double price;
  final String imageUrl;
  final String productName;
  final int  stockQuantity;

  ProductListedPageTile({
    Key? key,
    required this.harvestDate,
    required this.unit,
    required this.price,
    required this.imageUrl,
    required this.productName,
    required this.stockQuantity, required this.productID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20.0, left: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imageUrl),
                    )
                  : DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          'lib/customerSide/view/images/default_product_img.jpg'),
                    ), // Replace with your dummy image asset path
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                productName,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w800,
                  fontSize: 25.0,
                ),
              ),
              IconButton(
                onPressed: () {
                  productListPageController.updateStockQuantity(stockQuantity);
                  Get.to(
                    () => ProductAddToCartPage(
                       productId:productID,
                        img: imageUrl,
                        pricePerUnit: price,
                        stkQuantity: productListPageController.stockQuantity.value,
                        name: productName,
                        unit: unit),
                  );
                },
               
                icon: Icon(
                  Icons.add_circle,
                  size: 40,
                ),
              ),
            ],
          ),
          Text(
            "Harvested on: $harvestDate",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price per $unit :', // Assuming price is a double
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Colors.green.shade500, // Adjust color as needed
                ),
              ),
              Text(
                'LKR $price',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0,
                  color: Colors.green.shade800,
                ),
              ),

            ],

          ),
          stockQuantity==0?
          Text(

            "Sorry, out of Stock",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
              color: Colors.red.shade800,
            ),
          ):
          Text(

            '${stockQuantity} Available',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
              color: Colors.green.shade800,
            ),
          )
          ,
          Divider(
            thickness: 2.0,
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
