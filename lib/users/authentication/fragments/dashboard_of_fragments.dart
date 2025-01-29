import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mysql_db/users/authentication/userPreferences/current_user.dart';

class DashboardOfFragments extends StatelessWidget {
  // const DashboardOfFragments({super.key});

  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState){
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller){
        return Scaffold(
          appBar: AppBar(
            title: Text('dashboard'),
          ),
        );
      },
    );
  }
}
