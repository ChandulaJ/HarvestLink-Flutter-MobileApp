import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_delivery/customerSide/view/pages/farmersorted_home_page.dart';


import '../../controller/home_page_controller.dart';
import 'account_page.dart';
import 'cart_page.dart';
import 'home_page.dart';

class CustomerMainPage extends StatefulWidget {

  @override
  State<CustomerMainPage> createState() => _CustomerMainPageState();
}

class _CustomerMainPageState extends State<CustomerMainPage> {

  final HomePageController controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          if (controller.selectedTabIndex.value == 0) {
            // Show search bar only in the Home tab
            return EasySearchBar(
              title:  Text('Harvest~Link',style: GoogleFonts.montserratAlternates(fontSize: 25.0,fontWeight: FontWeight.w800),),
              onSearch: (value) {
                controller.setSearchValue(value);
              },
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              suggestions: controller.getMarketItemNames(),
            );
          } else {
            // Hide search bar in other tabs
            return AppBar(
              title: const Text('Harvest~Link'),
            );
          }
        }),
      ),
      body: Obx(() => controller.selectedTabIndex.value == 0
        //  ? CustomerHomePage()
          ?FarmerSortedCustomerHomePage()
          : controller.selectedTabIndex.value == 1
          ? CartPage()
          : AccountPage()),
      bottomNavigationBar: Obx(
        ()=> BottomNavigationBar(
          currentIndex: controller.selectedTabIndex.value,
          onTap: (index) {
            controller.setSelectedTabIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            ),
          ],


          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,

        ),
      ),
    );
  }
}
