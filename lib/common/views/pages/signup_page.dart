import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:get/get.dart';
import 'package:harvest_delivery/common/views/pages/signin_page.dart';
import 'package:harvest_delivery/customerSide/view/pages/home_page.dart';
import 'package:harvest_delivery/customerSide/view/pages/main_page.dart';

import 'package:sign_in_button/sign_in_button.dart';

import '../../controller/authFunctions.dart';
import '../components/farmerCustomerSelector.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool farmerSelected = false;
  final _formKey = GlobalKey<FormState>();

  void updateFarmerSelected(bool value) {
    setState(() {
      farmerSelected = value;
    });
  }

  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;

  bool _obscurePassword = true;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Svg(
              'lib/common/views/images/signin_background.svg',
              size: Size(10, 10),
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  SingleUserSelector(onSelectionChanged: updateFarmerSelected),

                  const SizedBox(height: 50.0),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Full name',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Full Name";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              fullname = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 16),
                        // Email
                        TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'E-mail',
                          ),
                          validator: (value) {
                            if (value!.isEmpty ||
                                !value.contains('@') ||
                                !value.contains('.')) {
                              return "Please Enter Valid Email";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              email = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Password',
                            suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                }),
                          ),
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Please Enter a Password of at least 6 letters";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (value) {
                            setState(() {
                              password = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Name

                  const SizedBox(height: 20.0),

                  // Button
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // login
                          //     ? AuthServices.signinUser(
                          //         email, password, context)
                          //     : AuthServices.signupUser(
                          //         email, password, fullname, context);
                          farmerSelected
                              ? AuthServices.signupFarmer(
                                  email, password, fullname, context)
                              : AuthServices.signupCustomer(
                                  email, password, fullname, context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Text
                  RichText(
                      text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                          children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to the Sign In screen
                              Get.to(SignInPage());
                            },
                        ),
                      ])),

                  const SizedBox(height: 16),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
