import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_delivery/customerSide/controller/product_list_page_controller.dart';
import 'package:harvest_delivery/customerSide/models/market_product_data_model.dart';
import 'package:harvest_delivery/customerSide/view/components/product_list_page_tile.dart';
import 'package:harvest_delivery/main.dart';

class ProductListedPage extends StatefulWidget {
  final String farmerId;
  final String farmerImage;
  final String farmerName;

  ProductListedPage(
      {required this.farmerId,
      required this.farmerName,
      required this.farmerImage,
      super.key});

  @override
  State<ProductListedPage> createState() => _ProductListedPageState();
}

class _ProductListedPageState extends State<ProductListedPage> {
  final ProductListPageController productListPageController =
      Get.put(ProductListPageController());

  @override
  void initState() {
    super.initState();
    productListPageController.fetchFarmerProducts(widget.farmerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            height: 200.0,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: widget.farmerImage.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.farmerImage),
                    )
                  : DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'lib/customerSide/view/images/default_product_img.jpg'),
                    ), // Replace with your dummy image asset path
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.farmerName,
                style: GoogleFonts.alata(
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade900,
                  fontSize: 30.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              List<MarketProductDataModel> productList =
                  productListPageController.farmerProducts;
              return ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  MarketProductDataModel farmerProduct = productList[index];

                  DateTime harvestDateNeeded = farmerProduct.date.toDate();
                  String formattedDate =
                      "${harvestDateNeeded.year}/${harvestDateNeeded.month}/${harvestDateNeeded.day}";
                  print("Product list id: ${farmerProduct.productId}");
                  return ProductListedPageTile(
                    farmerImg: widget.farmerImage,
                    farmerName: widget.farmerName,
                    farmerID: farmerProduct.farmerId,
                    harvestDate: formattedDate,
                    unit: farmerProduct.unit,
                    price: farmerProduct.price,
                    imageUrl: farmerProduct.imageUrl,
                    productName: farmerProduct.name,
                    stockQuantity: farmerProduct.stockQuantity,
                    productID: farmerProduct.productId,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
