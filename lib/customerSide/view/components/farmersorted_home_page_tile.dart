import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_delivery/customerSide/controller/farmersorted_home_page_controller.dart';
import 'package:harvest_delivery/customerSide/view/pages/more_details_page.dart';

import '../../controller/home_page_controller.dart';

class FarmersortedHomePageTile extends StatelessWidget {
  final FarmerHomePageController farmerhomePageController = Get.find();
  final String name;
  final String email;
  final String address;
  final String phoneNumber;

  FarmersortedHomePageTile({
    Key? key, required this.name, required this.email, required this.address, required this.phoneNumber,

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    

    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){},
            child: Container(
              height: 150.0,
              width: double.maxFinite,
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/harvestlink-99581.appspot.com/o/farmer_picture.jpg?alt=media&token=f7172814-1353-45ac-a6b9-30f1c1ef377c"),fit: BoxFit.cover)

              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            name,
            style: GoogleFonts.roboto(fontWeight: FontWeight.w800,fontSize: 25.0),
          ),
          Text(address,style:  GoogleFonts.roboto(fontWeight: FontWeight.w400,fontSize: 16.0),)
        ],
      ),
    );
  }
}
