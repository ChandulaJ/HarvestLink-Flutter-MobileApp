import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest_delivery/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_item.dart';
import 'update_item.dart';


class ItemScreen extends StatefulWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
    final Stream<QuerySnapshot> itemsStream = FirebaseFirestore.instance
      .collection('MarketProducts')
      .where('FarmerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

Future<void> deleteItem(String id) async {
  try {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await FirebaseFirestore.instance
          .collection('MarketProducts')
          .doc(id)
          .delete();
    }
  } catch (error) {
    print('Failed to delete item: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to delete item')),
    );
  }
}


  Future<String> getImageURL(String imagePath) async {
    final imageRef = FirebaseStorage.instance.ref().child(imagePath);
    return await imageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Items',
          style: TextStyle(
            fontSize: 28, 
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: itemsStream,
          builder: (context, snapshot) {
            try {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final List storedocs = snapshot.data!.docs
                  .map((doc) => {
                        'id': doc.id,
                        ...doc.data() as Map<String, dynamic>,
                      })
                  .toList();

              return ListView.builder(
                itemCount: storedocs.length,
                itemBuilder: (context, index) {
                  final itemData = storedocs[index];

                  return Column(
                    children: [
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        leading: FutureBuilder<String>(
                          future: itemData['ImageUrl'] != null
                              ? getImageURL(itemData['ImageUrl'])
                              : null,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            return CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(itemData['ImageUrl'] ?? ''),
                            );
                          },
                        ),
                        title: Text(
                          itemData['Name'] ?? '',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateItem(id: itemData['id']),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: const Color.fromARGB(255, 157, 27, 18),
                              onPressed: () => deleteItem(itemData['id']),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 0),
                    ],
                  );
                },
              );
            } catch (e) {
              print('Error in FutureBuilder: $e');
              return Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItem()),
          );
        },
        backgroundColor: MyApp.primaryColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
