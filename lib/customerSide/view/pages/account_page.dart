import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_delivery/common/views/pages/signin_page.dart';
import 'package:harvest_delivery/customerSide/controller/home_page_controller.dart';

import '../components/account_page_tile.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    HomePageController homePageController = Get.find();
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Image.asset(
            "lib/customerSide/view/images/user.png",
            height: 100.0,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            "James Anderson",
            style: GoogleFonts.cairo(fontSize: 25.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Edit Profile"),
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Divider(
            thickness: 2.0,
            indent: 10.0,
            endIndent: 10.0,
          ),
          const SizedBox(
            height: 20.0,
          ),
          AccountPageTile(
            title: "Location",
            subtitle: "22/B,2nd lane, Galle",
            tileicon: Icons.location_on_outlined,
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Divider(
            thickness: 2.0,
            indent: 10.0,
            endIndent: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
            homePageController.selectedTabIndex.value = 0;
              Get.to(()=>SignInPage());
            },
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                size: 40.0,
              ),
              title: Text(
                "Signout",
                style: GoogleFonts.cairo(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
