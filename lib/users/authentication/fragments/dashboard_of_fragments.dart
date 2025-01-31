import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mysql_db/users/authentication/fragments/home_fragment_screen.dart';
import 'package:mysql_db/users/authentication/fragments/profile_fragment_screen.dart';
import 'package:mysql_db/users/authentication/login_screen.dart';
import 'package:mysql_db/users/authentication/userPreferences/current_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardOfFragments extends StatelessWidget {
  // const DashboardOfFragments({super.key});

  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  List<Widget> _fragmentScreens =
  [
    HomeFragmentScreen(),
    ProfileFragmentScreen(),
  ];

  List _navigationButtonsProperties =
  [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home"
    },
    {
      "active_icon": Icons.person ,
      "non_active_icon": Icons.person_outline,
      "label": "Profile"
    },
  ];

  RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState){
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller){
        return Scaffold(
          // appBar: AppBar(
          //   // automaticallyImplyLeading: true,
          //   leading: IconButton(
          //       onPressed: (){
          //         Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen() ));
          //       },
          //       icon: Icon(Icons.arrow_back)
          //   ),
          //   centerTitle: true,
          //   title: Text('Dashboard'),
          // ),

          body: SafeArea(
              child: Obx(
                  ()=> _fragmentScreens[_indexNumber.value]
              ),
          ),
          bottomNavigationBar: Obx(
              ()=> BottomNavigationBar(
                backgroundColor: Colors.black,
                currentIndex: _indexNumber.value,
                onTap: (value){
                  _indexNumber.value = value;
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white24,
                items: List.generate(2, (index)
                {
                  var navBtnProperty = _navigationButtonsProperties[index];
                  return BottomNavigationBarItem(
                      backgroundColor: Colors.black,
                      icon: Icon(navBtnProperty["non_active_icon"]),
                      activeIcon: Icon(navBtnProperty["active_icon"]),
                      label: navBtnProperty["label"]
                  );
                }
                ),
              ),
          ),
        );
      },
    );
  }
}
