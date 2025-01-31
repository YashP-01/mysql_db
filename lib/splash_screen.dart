import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:mysql_db/users/authentication/fragments/dashboard_of_fragments.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      useImmersiveMode: false,
      duration: Duration(milliseconds: 2000),
      backgroundColor: Theme.of(context).colorScheme.surface,
      nextScreen: DashboardOfFragments(),
      splashScreenBody: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
