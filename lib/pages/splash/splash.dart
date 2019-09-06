import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kopidalar/pages/accounts/registerUser.dart';
import 'package:kopidalar/pages/accounts/signIn.dart';
import 'package:kopidalar/pages/home.dart';
import 'package:kopidalar/util/session_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  @override
  Widget build(BuildContext context){
    Future.delayed(Duration (seconds: 3)).then((_) async{
      String authID = await getUserLogin();
      if(authID != null && authID != ""){
        Query userData = Firestore.instance.collection('users').where("auth_uid", isEqualTo: authID);
        QuerySnapshot userDataSnapshot = await userData.getDocuments();
        if(userDataSnapshot.documents.isEmpty){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterUserPage()));
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
      else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage())
        );
      }
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: new Image.asset(
              'assets/graphics/kopidalar_white_logo.png',
              width: 250.0,
              height: 250.0,
            )
          ),
        ]
      ),
      backgroundColor: Colors.brown,
    );
  }
}