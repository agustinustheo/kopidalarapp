import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kopidalar/pages/accounts/signIn.dart';
import 'package:kopidalar/pages/accounts/signUp.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<IndexPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Kopi Dalar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            onPressed: navigateToSignIn,
            child: Text('Sign In'),
          ),
          RaisedButton(
            onPressed: navigateToSignUp,
            child: Text('Sign Up'),
          ),
        ],
      )
    );
  }

  void navigateToSignIn() async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void navigateToSignUp() async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}