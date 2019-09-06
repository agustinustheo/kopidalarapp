import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kopidalar/models/goods_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart{
  static List<Goods> orders;
}

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

Future<DocumentSnapshot> getUserByAuthUID(String auth_uid) async{
  Query user = Firestore.instance.collection('users').where("auth_uid", isEqualTo: auth_uid);
  QuerySnapshot data = await user.getDocuments();
  return data.documents[0];
}

Future<DocumentSnapshot> getUserByUsername(String username) async{
  Query user = Firestore.instance.collection('users').where("username", isEqualTo: username);
  QuerySnapshot data = await user.getDocuments();
  return data.documents[0];
}

Future<DocumentSnapshot> getGoodsByAuthUID(String auth_uid) async{
  Query user = Firestore.instance.collection('goods').where("uid", isEqualTo: auth_uid);
  QuerySnapshot data = await user.getDocuments();
  return data.documents[0];
}