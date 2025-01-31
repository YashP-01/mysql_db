import 'package:get/get.dart';
import 'package:mysql_db/users/authentication/model/user.dart';
import 'package:mysql_db/users/authentication/userPreferences/user_preferences.dart';

class CurrentUser extends GetxController{
  final Rx<User> _currentUser = User(0, '', '', '').obs;

  User get user => _currentUser.value;

  getUserInfo() async
  {
    User? currentUser = await RememberUserPref.readUserInfo();
    if (currentUser != null) {
      print("Logged in as: ${currentUser.user_name}");
    } else {
      print("No user found in SharedPreferences.");
    }


    // User? getUserInfoFromLocalStorage = await RememberUserPref.readUserInfo();
    // _currentUser.value = getUserInfoFromLocalStorage!;
  }
}