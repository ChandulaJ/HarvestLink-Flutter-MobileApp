import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest_delivery/farmerSide/models/farmer.dart';
import 'package:harvest_delivery/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  late User _user;
  late Farmer _farmer = Farmer(
    farmerId: '', // Provide a default value or an empty string
    name: '', // Provide a default value or an empty string
    phoneNumber: '', // Provide a default value or an empty string
    address: '', // Provide a default value or an empty string
    email: '', // Provide a default value or an empty string
    imageUrl: '', // Provide a default value or an empty string
  );

  late File _selectedImage = File(''); // Variable to store the selected image

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  void _loadUserData() async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('Farmers').doc(_user.uid).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data()!;
      setState(() {
        _farmer = Farmer(
          farmerId: _user.uid,
          name: userData['Name'] ?? '',
          phoneNumber: userData['Phone number'] ?? '',
          address: userData['Address'] ?? '',
          email: _user.email ?? '',
          imageUrl: userData['ImageUrl'] ?? '',
        );

        _nameController.text = _farmer.name;
        _addressController.text = _farmer.address;
        _emailController.text = _farmer.email;
        _phoneController.text = _farmer.phoneNumber;
      });
    }
  }

  bool isValidImage(File file) {
    try {
      img.decodeImage(file.readAsBytesSync());
      return true;
    } catch (e) {
      print('Invalid image file: $e');
      return false;
    }
  }

  void _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Check if a new image is selected before updating the database
        if (_selectedImage.path.isNotEmpty && isValidImage(_selectedImage)) {
          // Upload the selected image to Firebase Storage
          String imageName = 'profile_image_${_farmer.farmerId}.jpg';
          Reference storageReference = FirebaseStorage.instance.ref().child('farmer_images').child(imageName);
          UploadTask uploadTask = storageReference.putFile(_selectedImage!);

          await uploadTask.whenComplete(() async {
            String imageUrl = await storageReference.getDownloadURL();
            await FirebaseFirestore.instance.collection('Farmers').doc(_user.uid).update({
              'ImageUrl': imageUrl,
            });

          });
        }

        // Update other user data in the database (name, address, phone number)
        await FirebaseFirestore.instance.collection('Farmers').doc(_user.uid).update({
          'Name': _nameController.text,
          'Address': _addressController.text,
          'Phone number': _phoneController.text,
        });

        setState(() {
          _farmer.name = _nameController.text;
          _farmer.address = _addressController.text;
          _farmer.phoneNumber = _phoneController.text;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data updated successfully')),
        );
      } catch (error) {
        print('Failed to update user data: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user data')),
        );
      }
    }
  }

  void _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _farmer.imageUrl = pickedFile.path; // Update the UI immediately
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/signin');
  }

  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:_selectedImage.path.isNotEmpty
                              ? FileImage(_selectedImage) as ImageProvider<Object>
                              : NetworkImage(_farmer.imageUrl ?? ''),
                  
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _selectImage,
                ),
                SizedBox(height: 20),
                // Form Fields
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  readOnly: true,
                ),
                SizedBox(height: 16),
                TextFormField(
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 500));
                    RenderObject? object = globalKey.currentContext?.findRenderObject();
                    object?.showOnScreen();
                  },
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }

                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Please enter a valid phone number (only digits allowed)';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 32),
                // Save Changes and Sign Out Buttons
                ElevatedButton(
                  key: globalKey,
                  onPressed: _updateUserData,
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: MyApp.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _signOut,
                  child: Text('Sign Out', style: TextStyle(fontSize: 18.0)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: MyApp.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
