import 'package:firebase_auth/firebase_auth.dart';
import 'package:harvest_delivery/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChartData> _chartData = [];
  List<DoughnutChartData> _orderStatusData = []; 
  bool _isLoading = false;
  String _error = '';

  String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserName();
    _fetchOrderData();
  }

  Future<void> _fetchCurrentUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('Farmers').doc(user.uid).get();
      _currentUserName = doc.data()?['Name'] ?? '';
      setState(() {});
    }
  }

  Future<void> _fetchOrderData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final ordersSnapshot = await FirebaseFirestore.instance.collection('Orders').where('FarmerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

      final ordersByDate = <DateTime, int>{};
      for (final doc in ordersSnapshot.docs) {
        final orderDateTime = (doc.data()['DateTime'] as Timestamp).toDate();
        final orderDate = DateTime(orderDateTime.year, orderDateTime.month, orderDateTime.day);

        ordersByDate[orderDate] = (ordersByDate[orderDate] ?? 0) + 1;
      }

      _chartData = ordersByDate.entries
          .map((entry) => ChartData(date: entry.key, count: entry.value))
          .toList();

      final orderStatusCounts = <String, int>{
    'Pending': 0,
    'Accepted': 0,
    'Delivered': 0,
    'Cancelled': 0,
  };

  for (final doc in ordersSnapshot.docs) {
    final status = (doc.data()['Status'] ?? '') as String;
    orderStatusCounts[status] = (orderStatusCounts[status] ?? 0) + 1;
  }
          setState(() {
    _chartData = ordersByDate.entries
        .map((entry) => ChartData(date: entry.key, count: entry.value))
        .toList();
    _orderStatusData = orderStatusCounts.entries
        .map((entry) => DoughnutChartData(status: entry.key, count: entry.value))
        .toList();
  });

    } catch (error) {
      _error = 'Error fetching data: $error';
    } finally {
      setState(() {
        _isLoading = false;
      });

    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: MyApp.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, 
                        ),
                      ),
                      Text(
                        '$_currentUserName!',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

           Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Sales Analytics',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 9, 50, 126),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _error.isNotEmpty
                          ? Center(child: Text(_error))
                          : SfCartesianChart(
                              // Your chart settings here
                              primaryXAxis: CategoryAxis(),
                              series: <ChartSeries<ChartData, String>>[
                                LineSeries<ChartData, String>(
                                  dataSource: _chartData,
                                  xValueMapper: (data, _) => data.date.toString(),
                                  yValueMapper: (data, _) => data.count,
                                ),
                              ],
                            ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Order Status Insights',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 9, 50, 126),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    height: 200, // Set your desired height
                    child: SfCircularChart(
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.right,
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      series: <CircularSeries<DoughnutChartData, String>>[
                       DoughnutSeries<DoughnutChartData, String>(
                        dataSource: _orderStatusData,
                        xValueMapper: (data, _) => data.status,
                        yValueMapper: (data, _) => data.count,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        pointColorMapper: (data, _) {
                          
                          if (data.status == 'Pending') {
                            return Color.fromARGB(255, 185, 173, 83); 
                          } else if (data.status == 'Accepted') {
                            return Color.fromARGB(255, 60, 141, 122); 
                          } else if (data.status == 'Delivered') {
                            return Color.fromARGB(255, 86, 100, 155); 
                          } else if (data.status == 'Cancelled') {
                            return Color.fromARGB(97, 173, 116, 93); 
                          }
                          return Colors.grey; 
                        },
                      )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final DateTime date;
  final int count;

  ChartData({required this.date, required this.count});
}

class DoughnutChartData {
  final String status;
  final int count;

  DoughnutChartData({required this.status, required this.count});
}