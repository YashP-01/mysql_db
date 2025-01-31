import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mysql_db/splash_screen.dart';
import 'package:mysql_db/users/authentication/fragments/dashboard_of_fragments.dart';
import 'package:mysql_db/users/authentication/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_db/users/authentication/userPreferences/user_preferences.dart';

import 'model/user.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  loginUserNow() async {
    try {
      var res = await http.post(
        Uri.parse("http://192.168.3.76:8000/mysql_db_app/user/login.php"),
        body: jsonEncode({
          'user_email': _emailController.text.trim(),
          'user_password': _passwordController.text.trim(),
        }),
      );

      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        print(res.statusCode);
        print(resBodyOfLogin);

        if (resBodyOfLogin['success'] == true) {
          // Show success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logged in Successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // print("response data = "+resBodyOfLogin['userData']);

          // Check if 'userJsonData' exists and is not null
          if (resBodyOfLogin['userData'] != null) {

            print('User data: ${resBodyOfLogin['userData']}');
            User userInfo = User.fromJson(resBodyOfLogin['userData']);

            print(userInfo.user_name);

            // Save userInfo to local storage using shared preference.
            await RememberUserPref.storeUserInfo(userInfo);

            // Navigate to the dashboard
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SplashScreen()),
            );
          } else {
            // Show error snackbar if user data is not found
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User data not found.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // Show error snackbar for incorrect credentials
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect Credentials.\nPlease write correct email or password and Try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Show error snackbar for server connection failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect to the server. Status code: ${res.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (errorMsg) {
      // Show error snackbar for exceptions
      print("Error :: " + errorMsg.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        automaticallyImplyLeading: false,
        title: Text('Log In'),
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
                  size: screenWidth * 0.25,
                  color: Colors.lightBlue,
                ),
                SizedBox(height: 25),

                Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        /// email
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                              labelText: 'Email',
                              border: OutlineInputBorder()
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
                          obscureText: _isObscured,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.vpn_key_sharp,
                              color: Colors.grey,
                            ),
                              labelText: 'password',
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
                          validator: (value){
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
                          },
                        ),
                        SizedBox(height: 35),

                        ElevatedButton(
                          onPressed: () async {

                            if(_formKey.currentState!.validate()){
                              loginUserNow();

                              // Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardOfFragments()));
                            }
                            else
                              {
                                Fluttertoast.showToast(msg: "something went wrong, Try again later.");
                              }
                          },
                          child: Text('Log in'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(screenWidth * 0.8, 50),
                          ),
                        ),
                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("don't have an account?"),
                            TextButton(
                                onPressed: (){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignupScreen()),
                                  );
                                }, child: Text('register now'))
                          ],
                        )
                      ],
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}





// auth service
// final _auth = AuthService();
// if (_formKey.currentState?.validate() ?? false) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text('Signing in...')),
//   );
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => HomePage()),
//   );
// } else {
//   ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Please fill all the fields correctly.'))
//   );
// }
//
// // try login
// try {
//   await _auth.signInWithEmailPassword(_emailController.text, _passwordController.text);
// }
//
// // catch any errors
// catch (e) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text(e.toString()),
//     ),
//   );
// }