import 'dart:convert';
import 'package:mysql_db/users/authentication/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPref
{
  // remember user info
  static Future<void> storeUserInfo(User userInfo) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  // retrieve user info
  static Future<User?> getStoredUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userJsonData = preferences.getString('userJsonData');
    if (userJsonData != null) {
      return User.fromJson(jsonDecode(userJsonData));
    }
    return null;
  }

  // get user info
  static Future<User?> readUserInfo() async
  {
    User? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    if(userInfo != null){
        Map<String, dynamic> userDataMap = jsonDecode(userInfo);
        currentUserInfo = User.fromJson(userDataMap);
    }
    return currentUserInfo;
  }
}