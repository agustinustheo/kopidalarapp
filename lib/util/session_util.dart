import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> saveUserLogin(FirebaseUser user) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("user", user.uid);

  return prefs.commit();
}

Future<String> getUserLogin() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  return prefs.getString("user");
}

Future<bool> removeUserLogin() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("user", "");

  return prefs.commit();
}