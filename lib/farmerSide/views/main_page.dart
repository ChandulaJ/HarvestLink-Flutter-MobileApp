import 'package:flutter/material.dart';
import 'package:harvest_delivery/farmerSide/views/account_screen.dart';
import 'package:harvest_delivery/farmerSide/views/home_screen.dart';
import 'package:harvest_delivery/main.dart';

import 'item_screen.dart';
import 'order_screen.dart';

class FarmerMainPage extends StatefulWidget {
  const FarmerMainPage({Key? key}) : super(key: key);

  @override
  State<FarmerMainPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FarmerMainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ItemScreen(),
    OrderScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_all_outlined),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_selectedIndex == 0) {
      return AppBar(
        backgroundColor: MyApp.primaryColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 10.0, // Set your desired height
      );
    } else {
      return AppBar(
        backgroundColor: MyApp.primaryColor,
        automaticallyImplyLeading: false,
      );
    }
  }
}
