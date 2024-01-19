import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_delivery/customerSide/data/repositories/market_products_repository.dart';
import 'package:harvest_delivery/customerSide/view/pages/home_page.dart';
import 'package:harvest_delivery/customerSide/view/pages/main_page.dart';
import 'package:harvest_delivery/customerSide/view/pages/order_placed_page.dart';

import 'common/views/pages/signin_page.dart';
import 'farmerSide/views/main_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (FirebaseApp value) => Get.put(MarketProductsRepository()),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const Color primaryColor = Colors.blue;

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Harvest Link',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routes: {
        '/signin': (context) => SignInPage(),
      },

      //home: const MainPage(title: 'Harvest Link'),
      home: SignInPage(),
      //home:OrderPlacedPage(),
//home: CustomerMainPage(),

      // home:FarmerMainPage(),
    );
  }
}
