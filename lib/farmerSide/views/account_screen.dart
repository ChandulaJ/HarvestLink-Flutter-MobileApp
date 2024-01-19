import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harvest_delivery/farmerSide/models/farmer.dart';
import 'package:harvest_delivery/main.dart';

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
  late Farmer _farmer; 

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
          phoneNumber: userData['PhoneNumber'] ?? '',
          address: userData['Address'] ?? '',
          email: _user.email ?? '',
        );

        _nameController.text = _farmer.name;
        _addressController.text = _farmer.address;
        _emailController.text = _farmer.email;
        _phoneController.text = _farmer.phoneNumber;
      });
    }
  }

  void _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Farmers').doc(_user.uid).update({
          'Name': _nameController.text,
          'Address': _addressController.text,
          'PhoneNumber': _phoneController.text,
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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/signin');
  }

GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account', style: TextStyle(
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
                        RenderObject? object =
                            globalKey.currentContext?.findRenderObject();
                        object?.showOnScreen();
                      },
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                key: globalKey,
                onPressed: _updateUserData,
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: MyApp.primaryColor,
                        foregroundColor: Colors.white,
                      ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signOut,
                child: Text('Sign Out'),
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
        ),
      ),
      ),
    );
  }
}