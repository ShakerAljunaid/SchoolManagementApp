import 'package:ajialalsafaschool/models/GeneralClasses/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

Future<SharedPreferences> _sPrefs = SharedPreferences.getInstance();

Future<User> getSharedPref() async {
  final SharedPreferences prefs = await _sPrefs;

  Map<String, dynamic> userStr = jsonDecode(prefs.get("UseCredentials"));
  return new User(
      id: userStr["id"],
      schoolId: userStr["schoolId"],
      name: userStr["name"],
      isActive: userStr["isActive"],
      userGuid: userStr["userGuid"]);
}
