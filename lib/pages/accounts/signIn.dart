import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kopidalar/pages/accounts/signUp.dart';
import 'package:kopidalar/pages/home.dart';
import 'package:kopidalar/util/session_util.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.brown[600],
            Colors.brown[600],
            Colors.brown[500],
            Colors.brown[400],
          ],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        body: Form(
          key: _formKey,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                new Container(
                  width: 100.0,
                  height: 100.0,
                  margin: const EdgeInsets.only(
                    top: 65.0,
                    bottom: 50.0,
                  ),
                  child: new Image.asset('assets/graphics/kopidalar_white_logo.png'),
                ),
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30.0, 
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.all(
                    10.0,
                  ),
                  child: new SizedBox(
                    width: 275.0,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      validator: (input){
                        if(input.isEmpty){
                          return 'Please type an email';
                        }
                      },
                      onSaved: (input) => _email = input,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.all(
                    10.0,
                  ),
                  child: new SizedBox(
                    width: 275.0,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      validator: (input){
                        if(input.isEmpty){
                          return 'Please provide a password';
                        }
                        else if(input.length < 6){
                          return 'Your password needs to be atleast 6 characters';
                        }
                      },
                      onSaved: (input) => _password = input,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.all(
                    10.0,
                  ),
                  child: new SizedBox(
                    width: 255.0,
                    child: RaisedButton(
                      onPressed: signIn,
                      padding: EdgeInsets.all(13.0),
                      color: Colors.white,
                      child: Text(
                        'Sign In',
                        style: new TextStyle(
                          fontSize: 16.0, 
                          color: Colors.brown
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0)
                      ),
                    ),
                  ),
                ),
                new InkWell(
                    child: Text(
                      'Don\'t have an account? Sign Up here',
                      style: new TextStyle(
                        fontSize: 16.0, 
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignUpPage())
                      );
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async{
    final formState = _formKey.currentState;

    if(formState.validate()){
      formState.save();
      try{
        AuthResult authResult  = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password
        );
        FirebaseUser user = authResult.user;
        saveUserLogin(user);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      catch(e){
        print(e);
      }
    }
  }
}