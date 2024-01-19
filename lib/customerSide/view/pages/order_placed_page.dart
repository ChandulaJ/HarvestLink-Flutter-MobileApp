import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/customerSide/view/pages/home_page.dart';
import 'package:harvest_delivery/customerSide/view/pages/main_page.dart';
import 'package:lottie/lottie.dart';

class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Order Placed Successfully",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.left,
              ),
              Lottie.asset("lib/customerSide/view/images/done_animation_btn.json"),
              SizedBox(
                height: 60.0,
                width: 100.0,
                child: FilledButton(
                  onPressed: () {
                    Get.to(CustomerMainPage());
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}