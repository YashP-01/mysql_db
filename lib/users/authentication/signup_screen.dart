import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mysql_db/users/authentication/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_db/users/authentication/model/user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;

  // TextEditingController for each TextFormField
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  // email validation
  validateUserEmail() async{
    try
    {
      var res = await http.post(
        Uri.parse("http://192.168.3.76/mysql_db_app/user/validate_email.php"),
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
          // registerAndSaveUserRecord();
        }
      }
    }
    catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }


  registerAndSaveUserRecord() async {
    try {
      var res = await http.post(
        Uri.parse("http://192.168.3.76:8000/mysql_db_app/user/signup.php"),
        headers: {
          'Content-Type': 'application/json',  // Set the Content-Type to JSON
        },
        body: jsonEncode({
          'user_name': _nameController.text.trim(),
          'user_email': _emailController.text.trim(),
          'user_password': _passwordController.text.trim(),
        }),
      );

      if (res.statusCode == 200) {
        print("Response code is 200");
        print("Response body: ${res.body}");

        var resBodyOfSignUp = jsonDecode(res.body);

        print("response is: $resBodyOfSignUp");

        if (resBodyOfSignUp['success'] == true) {
          Fluttertoast.showToast(msg: 'Congratulations, Signup successful');
        } else {
          Fluttertoast.showToast(msg: 'Error occurred, Try again');
        }
      } else {
        print("Error: Server returned status code ${res.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: e.toString());
    }
  }



  // Password validation function
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z._]+$');
    return usernameRegex.hasMatch(username);
  }

  bool isValidEmail(String email) {
    // Regular expression for validating email
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                  Icons.account_circle,         /// add new avtar for profile icon here...
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address';
                          } else if (!isValidEmail(value)) {
                            return 'Invalid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      /// password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.vpn_key_sharp,
                            color: Colors.grey,
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscured ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: (){
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                            )
                        ),
                        validator: _validatePassword,
                      ),
                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            /// validate the email
                            validateUserEmail();
                            registerAndSaveUserRecord();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          }
                          else{
                            Fluttertoast.showToast(msg: 'something went wrong!');
                          }
                        },

                        child: Text('Sign Up'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(screenWidth * 0.8, 53),
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
