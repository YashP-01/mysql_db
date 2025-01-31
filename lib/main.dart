import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql_db/users/authentication/fragments/dashboard_of_fragments.dart';
import 'package:mysql_db/users/authentication/login_screen.dart';
import 'package:mysql_db/users/authentication/model/user.dart';
import 'package:mysql_db/users/authentication/signup_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:mysql_db/users/authentication/userPreferences/user_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<User?>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              // If user is found, show Dashboard
              return DashboardOfFragments();
            } else {
              // If no user found, show Login screen
              return LoginScreen();
            }
          }
        },
      ),
    );
  }

  Future<User?> _checkLoginStatus() async {
    // Fetch the stored user from SharedPreferences
    User? currentUser = await RememberUserPref.readUserInfo();
    return currentUser; // Returns user or null if no user is found
  }
}