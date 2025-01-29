import 'package:get/get.dart';
import 'package:mysql_db/users/authentication/model/user.dart';
import 'package:mysql_db/users/authentication/userPreferences/user_preferences.dart';

class CurrentUser extends GetxController{
  Rx<User> _currentUser = User(0, '', '', '').obs;

  User get user => _currentUser.value;

  getUserInfo() async
  {
    User? getUserInfoFromLocalStorage = await RememberUserPref.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}