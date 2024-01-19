import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harvest_delivery/main.dart';

import 'package:intl/intl.dart';

import 'order_details_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Orders',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 242, 242, 242),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Delivered'),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: TabBarView(
          children: [
            OrderTab(status: 'Pending'),
            OrderTab(status: 'Accepted'),
            OrderTab(status: 'Delivered'),
          ],
        ),
      ),
    );
  }
}

class OrderTab extends StatelessWidget {
  final String status;

  OrderTab({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 242, 242, 242),
      padding: EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('Status', isEqualTo: status)
            .snapshots(),
        builder: (context, snapshot) {
          try {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final orders = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                try {
                  final orderData =
                      orders[index].data() as Map<String, dynamic>;
                  return OrderCard(
                      orderData: orderData, id: orders[index].id);
                } catch (e) {
                  print('Error building OrderCard: $e');
                  return SizedBox.shrink();
                }
              },
            );
          } catch (e) {
            print('Error in StreamBuilder: $e');
            return Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  const OrderCard({Key? key, required this.orderData, required this.id})
      : super(key: key);

  final Map<String, dynamic> orderData;
  final id;

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.orderData['Status'] ?? 'Pending';
  }

  Future<Map<String, dynamic>> getCustomerDetails(String customerId) async {
    try {
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection('Customers')
          .doc(customerId)
          .get();
      return customerSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching customer details: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('MarketProducts')
          .doc(productId)
          .get();
      return productSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching product details: $e');
      return {};
    }
  }

  Widget _buildDropdownMenu() {
    return DropdownButton<String>(
      value: _selectedStatus,
      icon: Icon(Icons.arrow_drop_down, color: MyApp.primaryColor),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: MyApp.primaryColor, fontSize: 16),
      underline: Container(
        height: 2,
        color: MyApp.primaryColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatus = newValue!;
        });
        _updateOrderStatus();
      },
      items: <String>['Pending', 'Accepted', 'Delivered']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Future<void> _updateOrderStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(widget.id)
          .update({'Status': _selectedStatus});
    } catch (error) {
      print('Failed to update order status: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return FutureBuilder<Map<String, dynamic>>(
          future: getCustomerDetails(widget.orderData['CustomerId']),
          builder: (context, snapshot) {
            String customerName = snapshot.data?['Name'] ?? 'N/A';

            // Format the timestamp
            DateTime orderDateTime =
                (widget.orderData['DateTime'] as Timestamp).toDate();
            String formattedDateTime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(orderDateTime);

            return Card(
              elevation: 4,
               surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$customerName',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildDropdownMenu(),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Order Date: $formattedDateTime',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Divider(color: Colors.grey[400]),
                    SizedBox(height: 8),
                    // Display only the first 2 items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.orderData['Items'].length > 2
                          ? 2
                          : widget.orderData['Items'].length, // Limit to 2 items
                      itemBuilder: (context, index) {
                        try {
                          final item = widget.orderData['Items'][index];
                          return FutureBuilder<Map<String, dynamic>>(
                            future: getProductDetails(item['ProductId']),
                            builder: (context, productSnapshot) {
                              String productName =
                                  productSnapshot.data?['Name'] ?? 'N/A';
                              String unit = productSnapshot.data?['Unit'] ?? 'N/A';

                              return ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$productName ($unit)',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'x${item['Quantity']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } catch (e) {
                          print('Error building ListTile: $e');
                          return SizedBox.shrink(); // Return an empty widget if there's an error
                        }
                      },
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailsScreen(orderId: widget.id),
                              ),
                            );
                          },
                          child: Text(
                            'View Details',
                            style: TextStyle(
                              color: MyApp.primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    } catch (e) {
      print('Error building OrderCard: $e');
      return SizedBox.shrink(); // Return an empty widget if there's an error
    }
  }
}
