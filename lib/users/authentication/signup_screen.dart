import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysql_db/api_connection/api_connection.dart';
import 'package:mysql_db/users/authentication/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'model/user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingController for each TextFormField
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  // email validation
  validateUserEmail() async{
    try
    {
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'user_email': _emailController.text.trim(),
        }
      );
      if(res.statusCode == 200){
        var resBodyOfValidateEmail = jsonDecode(res.body);

        if(resBodyOfValidateEmail['emailFound'] == true){
          Fluttertoast.showToast(msg: 'email is already exist, Try another email.');
        } else {
          /// register and save new user record to the database.
          registerAndSaveUserRecord();
        }
      }
    }
    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  registerAndSaveUserRecord() async{
    User userModel = User(
      1,
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim()
    );

    try
    {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );

      if(res.statusCode == 200){
        var resBodyOfSignUp = jsonDecode(res.body);
        if(resBodyOfSignUp['success'] == true){
          Fluttertoast.showToast(msg: 'Congratulations, Signup successfully');
        }
        else{
          Fluttertoast.showToast(msg: 'Error Occurred, Try again');
        }
      }
    }
    catch(e)
    {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // Password validation function
  // String? _validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter a password';
  //   }
  //   if (value.length < 6) {
  //     return 'Password must be at least 6 characters';
  //   }
  //   if (!RegExp(r'\d').hasMatch(value)) {
  //     return 'Password must contain at least one number';
  //   }
  //   if (!RegExp(r'[A-Z]').hasMatch(value)) {
  //     return 'Password must contain at least one uppercase letter';
  //   }
  //   if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
  //     return 'Password must contain at least one special character';
  //   }
  //   return null;
  // }
  //
  // bool isValidUsername(String username) {
  //   final usernameRegex = RegExp(r'^[a-zA-Z._]+$');
  //   return usernameRegex.hasMatch(username);
  // }

  // bool isValidEmail(String email) {
  //   // Regular expression for validating email
  //   final emailRegex = RegExp(
  //     r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  //   );
  //   return emailRegex.hasMatch(email);
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    EdgeInsetsGeometry padding = screenWidth > 600
        ? EdgeInsets.symmetric(horizontal: 100)
        : EdgeInsets.symmetric(horizontal: 20);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: padding,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_circle,
                  size: screenWidth * 0.3,
                  color: Colors.lightBlue,
                ),
                SizedBox(height: 25),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      /// user name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      /// email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter an email address';
                        //   } else if (!isValidEmail(value)) {
                        //     return 'Invalid email address';
                        //   }
                        //   return null;
                        // },
                      ),
                      SizedBox(height: 20),

                      /// password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.vpn_key_sharp,
                            color: Colors.grey,
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        // validator: _validatePassword,
                      ),
                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {

                          if(_formKey.currentState!.validate()){

                            /// validate the email
                            validateUserEmail();
                          }
                        },
                        child: Text('Sign Up'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(screenWidth * 0.8, 50),
                        ),
                      ),
                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?'),
                          TextButton(
                            onPressed: () {
                              // Navigate to login page
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text('Log In'),
                          ),
                        ],
                      ),
                    ],
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
