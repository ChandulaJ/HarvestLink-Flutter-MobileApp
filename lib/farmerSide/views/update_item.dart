import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:harvest_delivery/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/harvest.dart';

class UpdateItem extends StatefulWidget {
  final String id;

  UpdateItem({Key? key, required this.id}) : super(key: key);

  @override
  _UpdateItemState createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController pickedDateTextController = TextEditingController();

  final _picker = ImagePicker();
  late File _image = File('');
  CollectionReference items =
      FirebaseFirestore.instance.collection('MarketProducts');

  bool isValidImage(File file) {
    try {
      img.decodeImage(file.readAsBytesSync());
      return true;
    } catch (e) {
      print('Invalid image file: $e');
      return false;
    }
  }

  Future<void> updateItem(Harvest harvest) async {
    String imageUrl = '';

    if (_image.path.isNotEmpty && isValidImage(_image)) {
      String imageName = DateTime.now().toString() + '.jpg';

      Reference storageReference =
          FirebaseStorage.instance.ref().child('item_images').child(imageName);
      UploadTask uploadTask = storageReference.putFile(_image);

      await uploadTask.whenComplete(() async {
        imageUrl = await storageReference.getDownloadURL();
        harvest.image = imageUrl;

        await items
            .doc(widget.id)
            .update({
              'Name': harvest.name,
              'Price': harvest.price,
              'StockQuantity': harvest.quantity,
              'Unit': harvest.unit,
              'HarvestedDate': harvest.harvestedDate,
              'ImageUrl': harvest.image,
              'FarmerId': harvest.farmerId,
            })
            .then((value) => print("Item Updated"))
            .catchError((error) => print("Failed to update item: $error"));
      });
    } else {
      // If no new image is selected, update the item without changing the image
      await items
          .doc(widget.id)
          .update({
            'Name': harvest.name,
            'Price': harvest.price,
            'StockQuantity': harvest.quantity,
            'Unit': harvest.unit,
            'HarvestedDate': harvest.harvestedDate,
            'FarmerId': harvest.farmerId,
          })
          .then((value) => print("Item Updated"))
          .catchError((error) => print("Failed to update item: $error"));
    }

    return items
        .doc(widget.id)
        .update({
          'Name': harvest.name,
          'Price': harvest.price,
          'StockQuantity': harvest.quantity,
          'Unit': harvest.unit,
          'HarvestedDate': harvest.harvestedDate,
          'FarmerId': harvest.farmerId,
        })
        .then((value) => print("Item Updated"))
        .catchError((error) => print("Failed to update item: $error"));
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Update Item",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: MyApp.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('MarketProducts')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('Something Went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var data = snapshot.data!.data();

              if (data == null) {
                return Center(
                  child: Text('No data found for ID: ${widget.id}'),
                );
              }

              Timestamp? timestamp =
                  snapshot.data?['HarvestedDate'] as Timestamp?;
              DateTime? harvestedDate;

              if (timestamp != null) {
                harvestedDate = timestamp.toDate();
                pickedDateTextController.text =
                    DateFormat('yyyy-MM-dd').format(harvestedDate);
              } else {
                // Handle the case when 'HarvestedDate' is null
                // You can assign a default value or perform some other logic
              }

              Harvest harvest = Harvest(
                produceId: widget.id,
                name: data['Name'],
                price: data['Price'],
                quantity: data['StockQuantity'],
                unit: data['Unit'],
                harvestedDate: harvestedDate ?? DateTime.now(),
                image: '',
                farmerId: FirebaseAuth.instance.currentUser!.uid,
              );

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _image.path.isNotEmpty
                              ? FileImage(_image) as ImageProvider<Object>
                              : NetworkImage(data['ImageUrl'] ?? ''),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: pickImage,
                      child: Text('Change Image'),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: TextEditingController(text: harvest.name),
                      onChanged: (value) => harvest.name = value,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      onTap: () async {
                        await Future.delayed(Duration(milliseconds: 500));
                        RenderObject? object =
                            globalKey.currentContext?.findRenderObject();
                        object?.showOnScreen();
                      },
                      controller: TextEditingController(text: harvest.unit),
                      onChanged: (value) => harvest.unit = value,
                      decoration: InputDecoration(
                        labelText: 'Unit',
                        labelStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      onTap: () async {
                        await Future.delayed(Duration(milliseconds: 500));
                        RenderObject? object =
                            globalKey.currentContext?.findRenderObject();
                        object?.showOnScreen();
                      },
                      controller:
                          TextEditingController(text: harvest.price.toString()),
                      onChanged: (value) => harvest.price = double.parse(value),
                      decoration: InputDecoration(
                        labelText: 'Unit Price',
                        labelStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      onTap: () async {
                        await Future.delayed(Duration(milliseconds: 500));
                        RenderObject? object =
                            globalKey.currentContext?.findRenderObject();
                        object?.showOnScreen();
                      },
                      controller: TextEditingController(
                          text: harvest.quantity.toString()),
                      onChanged: (value) => harvest.quantity = int.parse(value),
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        labelStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      readOnly: true,
                      controller: pickedDateTextController,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: harvestedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null && pickedDate != harvestedDate) {
                          harvestedDate = pickedDate;
                          pickedDateTextController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Harvested Date',
                        labelStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(),
                        errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      key: globalKey,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateItem(harvest);
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Update', style: TextStyle(fontSize: 18.0)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: MyApp.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
