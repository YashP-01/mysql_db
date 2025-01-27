import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mysql_db/users/authentication/login_screen.dart';
import 'package:mysql_db/users/authentication/signup_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(future: null, builder: (context, dataSnapShot)
      {
        return SignupScreen();
      })
    );
  }
}


